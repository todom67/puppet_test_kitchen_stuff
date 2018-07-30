
filepath = os[:family] == 'redhat' ? '/tmp' : 'c:\temp'

control 'te2-ctl-01' do
  title "testing #{filepath}/from_example_2"
  describe file("#{filepath}/from_example_2") do
    it { should exist }
    its('type') { should eq :file }
    its('mode') { should cmp '0644' }
    its('owner') { should eq 'root' }
    its('content') { should match(/Linux/) }
  end
end