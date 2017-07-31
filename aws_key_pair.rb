require 'chef/provisioning/aws_driver'

with_driver 'aws::us-east-1'

aws_key_pair 'pc-jenkins-key' do
  private_key_options({
    :format => :pem,
    :type => :rsa,
    :regenerate_if_different => true
  })
  allow_overwrite true
end

