title 'Check the traefik confio'

control 'ports-1.0' do
  impact 1.0
  title 'Port 80 should be in use by traefik'
  describe port(80) do
    it { should be_listening }
    its('processes') {should include 'traefik'}
  end
end

control 'ports-2.0' do
  impact 1.0
  title 'Port 8080 should be in use by consul'
  describe port(8080) do
    it { should be_listening }
    its('processes') {should include 'traefik'}
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

control 'directories-1.0' do
  impact 1.0
  title 'Consul config directory is created'
  describe file('/etc/traefik.d') do
    it { should exist }
    it { should be_directory }
  end
end

control 'files-1.0' do
  impact 1.0
  title 'Consul config file is created'
  describe file('/etc/traefik.d/traefik.toml') do
    it { should exist }
  end
end