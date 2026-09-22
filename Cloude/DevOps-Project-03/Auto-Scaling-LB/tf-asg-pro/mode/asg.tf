resource "aws_autoscaling_group" "CPU_stress_asg" {
  name                = "CPU-stress-asg"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.CPU_stress_Subnet.id,aws_subnet.CPU_stress_Subnet_2.id]

  launch_template {
    id      = aws_launch_template.golden_machin_template.id
    version = "$Latest"
  }


  target_group_arns = [aws_lb_target_group.CPU_stress_tg.arn]

  tag {
    key                 = "Name"
    value               = "ASG-Instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_scale_up" {
  name                    = "cpu-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  autoscaling_group_name = aws_autoscaling_group.CPU_stress_asg.name
}


resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "30"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.CPU_stress_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.cpu_scale_up.arn]
}

resource "aws_autoscaling_policy" "cpu_scale_down" {
  name                   = "cpu-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  autoscaling_group_name = aws_autoscaling_group.CPU_stress_asg.name
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "30"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.CPU_stress_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.cpu_scale_down.arn]
}