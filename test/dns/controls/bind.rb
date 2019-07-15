control 'bind-1.0' do
  impact 1.0
  title 'Port 53 should be in use by named'
  describe port(53) do
    it { should be_listening }
  end
end