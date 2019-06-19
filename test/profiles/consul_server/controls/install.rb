include_controls 'consul_client' do
  skip_control 'ports-1.0'
  skip_control 'ports-3.0'
end

control 'consul-ports-1.0' do
  impact 1.0
  title 'Port 8300 should be in use by consul'
  describe port(8300) do
    it { should be_listening }
  end
end

control 'consul-ports-3.0' do
  impact 1.0
  title 'Port 8302 should be in use by consul'
  describe port(8302) do
    it { should be_listening }
  end
end
