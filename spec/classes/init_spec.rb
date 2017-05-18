require 'spec_helper'

describe 'ptpd' do
  let(:title) { 'ptpd' }
  let(:facts){ {
    :path => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
  } }

  it { should create_class('ptpd') }

  it {should contain_package('ptpd')
    .with_ensure('installed')
  }

  it {should contain_service('ptpd2')
    .with({
    :ensure => 'running',
    :enable => 'true',
    :hasstatus => 'true',
    :hasrestart => 'true',
    :require => 'Package[ptpd]',
  } )
  }

  context 'with ptp_master => true' do
    let(:params){ {
      :ptp_master => true, 
      :ptpinterface => 'eth0'
    } } 

    it do 
      is_expected.to contain_file('/etc/ptpd2.conf')\
        .with_content(/ptpengine:preset=masteronly/)
        .with_content(/ptpengine:interface=eth0/)
        .with({
        :ensure => 'file',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
      })
    end
  end

  context 'with ptp_master => false' do
    let(:params) { {
      :ptp_master => false,
      :ptpinterface => 'eth0'
    } }

    it do      
      is_expected.to contain_file('/etc/ptpd2.conf')\
        .with_content(/ptpengine:preset=serveronly/) 
        .with_content(/ptpengine:interface=eth0/)
        .with({
        :ensure => 'file',
        :owner => 'root',
        :group => 'root',
        :mode => '0644',
      })

    end
  end
end





