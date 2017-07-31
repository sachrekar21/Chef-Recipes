machine_batch do
  machines %w(pc-swarm-master-a pc-swarm-master-b)
  action :destroy
end

#Create EC2 instances which will be docker swarm masters

machine_batch do
  machine 'pc-swarm-master-a' do
    machine_options bootstrap_options: {
    subnet: 'pc-vpc-subnet-a',
    key_name: 'pc-key',
    key_path: '/home/ubuntu/.ssh',
    instance_type: 't2.micro',
	security_groups: [pc-qa-vpc-sg],
    associate_public_ip_address: true }
  end

  machine 'pc-swarm-master-b' do
    machine_options bootstrap_options: {
    subnet: 'pc-vpc-subnet-b',
    key_name: 'pc-key',
    key_path: '/home/ubuntu/.ssh',
    instance_type: 't2.micro',
	security_groups: [pc-qa-vpc-sg],
    associate_public_ip_address: true }
  end
end
