include_controls 'vault'

control 'vault-config-1.0' do
  impact 1.0
  title 'vault config file is created'
  describe file('/etc/consul.d/service_vault-ui.json') do
    it { should exist }
  end
end