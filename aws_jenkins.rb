require 'chef/provisioning/aws_driver'
with_driver 'aws::us-east-1'

machine_batch do
  machine 'pc-jenkins-master' do
    machine_options bootstrap_options: {
    key_name: 'pc-jenkins-key',
    key_path: '/home/ubuntu/.ssh',
    image_id: "ami-65725b1e", # Image with Jenkins pre installed
    instance_type: "t2.medium",
    network_interfaces: [
    {
      associate_public_ip_address: true,
      device_index: 0,
      subnet_id: "PUT_YOUR_SUBNET_ID HERE",
      groups: ["PUT_YOUR_SG_ID_HERE"] }
      ],
 }
 end
end
