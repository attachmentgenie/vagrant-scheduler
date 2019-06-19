include_controls 'nomad_server'

control 'nomad-config-1.0' do
  impact 1.0
  title 'Nomad config file is created'
  describe file('/etc/consul.d/service_nomad-ui.json') do
    it { should exist }
  end
end