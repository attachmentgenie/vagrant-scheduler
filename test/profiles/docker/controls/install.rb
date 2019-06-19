title 'Check the consul confio'

control 'version-1.0' do
  impact 1.0
  title 'version should be relevant'
  describe docker.version do
    its('Server.Version') { should cmp >= '1.12'}
    its('Client.Version') { should cmp >= '1.12'}
  end
end