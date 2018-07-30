
filepath = os[:family] == 'redhat' ? '/tmp' : 'c:\temp'

control 'sfd-ctl-01' do
  title 'demo user'
  desc "Demo user shold be created by puppet"
  describe user('demo_user') do
    it { should exist }
  end
end

control 'sfd-ctl-02' do
  title "testing #{filepath}/my_dir"
  desc "File #{filepath}/my_dir shold be created by puppet"
  describe file("#{filepath}/my_dir") do
    it { should exist }
    its('type') { should eq :directory }
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'root' }
  end
end

control 'sfd-ctl-03' do
  title "testing #{filepath}/my_dir/my_file_template.txt"
  describe file("#{filepath}/my_dir/my_file_template.txt") do
    it { should exist }
    its('type') { should eq :file }
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'root' }
    its('content') { should match(/RedHat/) }
#    its('content') { should match(/10.207.141.8/) }
  end
end

control 'sfd-ctl-04' do
  title "testing #{filepath}/my_dir/my_file_static.txt"
  describe file("#{filepath}/my_dir/my_file_static.txt") do
    it { should exist }
    its('type') { should eq :file }
    its('mode') { should cmp '0644' }
    its('owner') { should eq 'root' }
    its('content') { should match(/THIS FILE MANAGED BY PUPPET!!!/) }
  end
end

control 'sfd-ctl-05' do
  title "testing #{filepath}/my_dir/my_file_content.txt"
  describe file("#{filepath}/my_dir/my_file_content.txt") do
    it { should exist }
    its('type') { should eq :file }
    its('mode') { should cmp '0644' }
    its('owner') { should eq 'demo_user' }
    its('content') { should match(/FROM SITE.PP/) }
  end
end
