require 'chef/provisioning/aws_driver'

with_driver 'aws::us-east-1'

aws_security_group "pc-qa-vpc-sg" do
  inbound_rules [
    {:port => 8080, :protocol => :tcp, :sources => ["0.0.0.0/0"] },
	{:port => 9090, :protocol => :tcp, :sources => ["0.0.0.0/0"] },
	{:port => 8888, :protocol => :tcp, :sources => ["0.0.0.0/0"] },
	{:port => 8761, :protocol => :tcp, :sources => ["0.0.0.0/0"] },
	{:port => 9411, :protocol => :tcp, :sources => ["0.0.0.0/0"] },
    {:port => 22, :protocol => :tcp, :sources => ["64.128.208.115/32"] } #Whitebox IP address
  ]
  outbound_rules [
    {:port => 8080, :protocol => :tcp, :destinations => ["0.0.0.0/0"] },
	{:port => 9090, :protocol => :tcp, :destinations => ["0.0.0.0/0"] },
	{:port => 8888, :protocol => :tcp, :destinations => ["0.0.0.0/0"] },
	{:port => 8761, :protocol => :tcp, :destinations => ["0.0.0.0/0"] },
	{:port => 9411, :protocol => :tcp, :destinations => ["0.0.0.0/0"] },
    {:port => 22, :protocol => :tcp, :destinations => ["64.128.208.115/32"] } #Whitebox IP address
  ]
  vpc "pc-qa-vpc"
end

aws_security_group "pc-jenkins-sg" do #Only accessible from whitebox IP address
  inbound_rules [
	{:port => 8080, :protocol => :tcp, :sources => ["64.128.208.115/32"] },
    {:port => 22, :protocol => :tcp, :sources => ["64.128.208.115/32"] } 
  ]
   outbound_rules [
	{:port => 8080, :protocol => :tcp, :destinations => ["64.128.208.115/32"] },
    {:port => 22, :protocol => :tcp, :destinations => ["64.128.208.115/32"] } 
  ] 
  vpc "pc-build-vpc"
  security_group_id "sg-bef3f1cf"
end

