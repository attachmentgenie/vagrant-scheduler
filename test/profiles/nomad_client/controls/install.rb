title 'Check the nomad confio'

control 'ports-1.0' do
  impact 1.0
  title 'Port 4646 should be in use by nomad'
  describe port(4646) do
    it { should be_listening }
    its('processes') {should include 'nomad'}
  end
end

control 'ports-2.0' do
  impact 1.0
  title 'Port 4647 should not be in use by nomad'
  describe port(4647) do
    it { should_not be_listening }
  end
end

control 'ports-3.0' do
  impact 1.0
  title 'Port 4648 should not be in use by nomad'
  describe port(4648) do
    it { should_not be_listening }
  end
end

control 'directories-1.0' do
  impact 1.0
  title 'nomad config directory is created'
  describe file('/etc/nomad.d') do
    it { should exist }
    it { should be_directory }
  end
end

control 'files-1.0' do
  impact 1.0
  title 'nomad config file is created'
  describe file('/etc/nomad.d/config.json') do
    it { should exist }
  end
end