external_facts_path = '/opt/puppetlabs/facter/facts.d/' 

control 'facts-1' do 
    title 'location fact cloud'
    desc "#{external_facts_path}location.txt should reflect whether node is in cloud or in terrestrial datacenter"
    describe file("#{external_facts_path}location.txt") do
      it { should exist }
      its('type') { should eq :file }
      its('mode') { should cmp '0644' }
      its('owner') { should eq 'root' }
      its('content') { should match(/location=aws_us_east_1|ch3|gcp_central_us|gt|mf|stores/) }
    end
end

control 'facts-2' do 
    title 'k_env fact nonpord'
    desc "#{external_facts_path}k_env.txt should be prod, nonprod, or sbox"
    describe file("#{external_facts_path}k_env.txt") do
      it { should exist }
      its('type') { should eq :file }
      its('mode') { should cmp '0644' }
      its('owner') { should eq 'root' }
      its('content') { should match(/k_env=nonprod|prod|sandbox/) }
    end
end