require 'chef/provisioning/aws_driver'
with_driver 'aws::us-east-1'

machine_batch do
  machine 'pc-jenkins-master' do
    machine_options bootstrap_options: {
    key_name: 'pc-jenkins-key',
    key_path: '/home/ubuntu/.ssh',
    image_id: "ami-6c376e17", # Image with Jenkins pre installed
    instance_type: "t2.micro",
    network_interfaces: [
    {
      associate_public_ip_address: true,
      device_index: 0,
      subnet_id: "subnet-3fee8e13",
      groups: ["sg-bef3f1cf"] }
      ],
 }
 end
end
