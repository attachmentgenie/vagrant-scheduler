include_controls 'traefik'

control 'config-1.0' do
  impact 1.0
  title 'Consul config file is created'
  describe file('/etc/consul.d/service_traefik.json') do
    it { should exist }
  end
end
