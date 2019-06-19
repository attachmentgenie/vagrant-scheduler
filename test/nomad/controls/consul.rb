include_controls 'consul_server'

control 'consul-config-1.0' do
  impact 1.0
  title 'Consul config file is created'
  describe file('/etc/consul.d/service_consul-ui.json') do
    it { should exist }
  end
end