title 'Check the consul confio'

control 'ports-1.0' do
  impact 1.0
  title 'Port 8300 should not be in use by consul'
  describe port(8300) do
    it { should_not be_listening }
  end
end

control 'ports-2.0' do
  impact 1.0
  title 'Port 8301 should be in use by consul'
  describe port(8301) do
    it { should be_listening }
    its('processes') {should include 'consul'}
  end
end

control 'ports-3.0' do
  impact 1.0
  title 'Port 8302 should not be in use by consul'
  describe port(8302) do
    it { should_not be_listening }
  end
end

control 'ports-4.0' do
  impact 1.0
  title 'Port 8500 should be in use by consul'
  describe port(8500) do
    it { should be_listening }
    its('processes') {should include 'consul'}
  end
end

control 'ports-5.0' do
  impact 1.0
  title 'Port 8600 should be in use by consul'
  describe port(8600) do
    it { should be_listening }
    its('processes') {should include 'consul'}
  end
end

control 'directories-1.0' do
  impact 1.0
  title 'Consul config directory is created'
  describe file('/etc/consul.d') do
    it { should exist }
    it { should be_directory }
  end
end

control 'directories-2.0' do
  impact 1.0
  title 'Consul var directory is created'
  describe file('/var/lib/consul') do
    it { should exist }
    it { should be_directory }
  end
end

control 'files-1.0' do
  impact 1.0
  title 'Consul config file is created'
  describe file('/etc/consul.d/config.json') do
    it { should exist }
  end
end