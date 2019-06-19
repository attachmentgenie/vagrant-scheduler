title 'Check the vault confio'

control 'ports-1.0' do
  impact 1.0
  title 'Port 8200 should be in use by vault'
  describe port(8200) do
    it { should be_listening }
    its('processes') {should include 'vault'}
  end
end

control 'ports-2.0' do
  impact 1.0
  title 'Port 8201 should be in use by vault'
  describe port(8201) do
    it { should be_listening }
    its('processes') {should include 'vault'}
  end
end

control 'directories-1.0' do
  impact 1.0
  title 'vault config directory is created'
  describe file('/etc/vault.d') do
    it { should exist }
    it { should be_directory }
  end
end

control 'files-1.0' do
  impact 1.0
  title 'vault config file is created'
  describe file('/etc/vault.d/config.json') do
    it { should exist }
  end
end