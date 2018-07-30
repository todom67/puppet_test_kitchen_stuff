# external_facts_path = '/opt/puppetlabs/facter/facts.d/' 
# gce_check =  describe file("#{external_facts_path}location.txt") do
#                 its('content') { should match(/location=gcp_central_us/) }
#             end
# control 'NetworkManager package' do
#   describe package('NetworkManager') do
#     it { should be_installed }
#   end
#   only_if gce_check
# end
control 'base rhel7 packages' do
  title "Ensure these packages are installed"
    describe package('augeas') do
      it { should be_installed }
    end
    describe package('iotop') do
      it { should be_installed }
    end
    describe package('lsof') do
      it { should be_installed }
    end
    describe package('nmap-ncat') do
      it { should be_installed }
    end
    describe package('psmisc') do
      it { should be_installed }
    end
    describe package('sos') do        
      it { should be_installed }
    end
    describe package('xfsdump') do
      it { should be_installed }
    end
    describe package('mlocate') do
      it { should be_installed }
    end
  end

  control 'base rhel7 unsecure packages' do
  title "Ensure these packages are not installed"
    
    describe package('bluez') do          
      it { should_not be_installed}
    end
    describe package('aic94xx-firmware') do
      it { should_not be_installed }
    end
    describe package('btrfs-progs') do
      it { should_not be_installed }
    end
    describe package('iprutils') do
      it { should_not be_installed }
    end
    describe package('ivtv-firmmware') do
      it { should_not be_installed }
    end
    describe package('NetworkManager-team') do
      it { should_not be_installed }
    end
    describe package('teamd') do          
      it { should_not be_installed }
    end
    describe package('NetworkManager-tui') do
      it { should_not be_installed }
    end
    describe package('NetworkManager-config-server') do
      it { should_not be_installed }
    end
    describe package('NetworkManagerlibnm') do
      it { should_not be_installed }
    end
    
end
