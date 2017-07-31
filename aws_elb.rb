require 'chef/provisioning/aws_driver'

with_driver 'aws::us-east-1'

#Create ELB to direct traffic
load_balancer "pc-elb" do
  load_balancer_options({
    subnets: ["pc-qa-public-subnet-a","pc-qa-public-subnet-b"],
    security_groups:["pc-qa-vpc-sg"],
    listeners: [
      {
          instance_port: 8080,
          protocol: 'HTTP',
          instance_protocol: 'HTTP',
          port: 8080
      },
      {
          instance_port: 8761,
          protocol: 'HTTP',
          instance_protocol: 'HTTP',
          port: 8761
      },
      {
          instance_port: 8888,
          protocol: 'HTTP',
          instance_protocol: 'HTTP',
          port: 8888
      },
      {
          instance_port: 9090,
          protocol: 'HTTP',
          instance_protocol: 'HTTP',
          port: 9090
      },
      {
          instance_port: 9411,
          protocol: 'HTTP',
          instance_protocol: 'HTTP',
          port: 9411
      },
    ],
    health_check: {
      healthy_threshold: 2,
      unhealthy_threshold: 4,
      interval: 12,
      timeout: 5,
      target: 'HTTP:8080/'
    }
  })
  end
  #Launch Configurations
  aws_launch_configuration 'pc-launch-configuration' do
  image 'ami-a4c7edb2'
  instance_type 't2.micro'
  options  security_groups: ['pc-qa-vpc-sg'],
  key_name: 'pc-key'
  aws_tags {Name: 'pc_swarm_master'}
  end


  #Auto Scaling Group

  aws_auto_scaling_group 'pc-auto-scaling-group' do
  availability_zones ['us-east-1a','us-east-1b']
  desired_capacity 2
  min_size 2
  max_size 3
  launch_configuration 'pc-launch-configuration'
  load_balancers 'pc-elb'
  options subnets: ['pc-qa-public-subnet-a','pc-qa-public-subnet-b'],
  aws_tags {Name: 'pc_swarm_master'}
end
