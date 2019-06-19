include_controls 'nomad_client' do
  skip_control 'ports-2.0'
  skip_control 'ports-3.0'
end

control 'nomad-ports-2.0' do
  impact 1.0
  title 'Port 4647 should be in use by nomad'
  describe port(4647) do
    it { should be_listening }
    its('processes') {should include 'nomad'}
  end
end

control 'nomad-ports-3.0' do
  impact 1.0
  title 'Port 4648 should be in use by nomad'
  describe port(4648) do
    it { should be_listening }
    its('processes') {should include 'nomad'}
  end
end