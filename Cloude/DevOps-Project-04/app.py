import os
import boto3
from botocore.exceptions import ClientError
from flask import Flask, render_template, request, redirect, url_for, session, flash
from werkzeug.security import generate_password_hash, check_password_hash
import sqlite3

app = Flask(__name__)
app.secret_key = 'super-secret-key-change-in-production'


S3_BUCKET = os.environ.get('S3_BUCKET_NAME', 'dolev-my-first-bucket-123')
REGION_NAME = os.environ.get('AWS_REGION', 'us-east-1')
s3_client = boto3.client('s3', region_name=REGION_NAME)

def get_db():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    with get_db() as conn:
        conn.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL
            )
        ''')
        conn.commit()

init_db()

@app.route('/')
def index():
    if 'user' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        db = get_db()
        user = db.execute('SELECT * FROM users WHERE username = ?', (username,)).fetchone()
        
        if user and check_password_hash(user['password'], password):
            session['user'] = username
            return redirect(url_for('dashboard'))
        flash('שם משתמש או סיסמה שגויים')
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = generate_password_hash(request.form['password'])
        
        try:
            db = get_db()
            db.execute('INSERT INTO users (username, password) VALUES (?, ?)', (username, password))
            db.commit()
            return redirect(url_for('login'))
        except sqlite3.IntegrityError:
            flash('שם המשתמש כבר קיים במערכת')
    return render_template('login.html', register=True)

@app.route('/dashboard')
def dashboard():
    if 'user' not in session:
        return redirect(url_for('login'))
    
    username = session['user']
    files = []
    
    prefix = f"{username}/"
    try:
        response = s3_client.list_objects_v2(Bucket=S3_BUCKET, Prefix=prefix)
        if 'Contents' in response:
            for obj in response['Contents']:
                file_key = obj['Key']
                file_name = file_key[len(prefix):]
                if file_name:
                    files.append({'name': file_name, 'key': file_key})
    except ClientError as e:
        print(e)
        
    return render_template('dashboard.html', username=username, files=files)

@app.route('/get-upload-url', methods=['POST'])
def get_upload_url():
    if 'user' not in session:
        return {'error': 'Unauthorized'}, 401
    
    file_name = request.json.get('file_name')
    username = session['user']
    s3_key = f"{username}/{file_name}"
    
    try:
        presigned_url = s3_client.generate_presigned_url(
            'put_object',
            Params={
                'Bucket': S3_BUCKET,
                'Key': s3_key,
                'ContentType': 'application/octet-stream'
            },
            ExpiresIn=300
        )
        return {'url': presigned_url}
    except ClientError as e:
        return {'error': str(e)}, 500

@app.route('/get-download-url', methods=['POST'])
def get_download_url():
    if 'user' not in session:
        return {'error': 'Unauthorized'}, 401
        
    file_key = request.json.get('file_key')
    if not file_key.startswith(f"{session['user']}/"):
        return {'error': 'Forbidden'}, 403
        
    try:
        presigned_url = s3_client.generate_presigned_url(
            'get_object',
            Params={'Bucket': S3_BUCKET, 'Key': file_key},
            ExpiresIn=300
        )
        return {'url': presigned_url}
    except ClientError as e:
        return {'error': str(e)}, 500

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)