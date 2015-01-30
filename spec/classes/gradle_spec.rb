require 'spec_helper'
require 'shared_contexts'

describe 'gradle' do
    # by default the hiera integration uses hirea data from the shared_contexts.rb file
    # but basically to mock hiera you first need to add a key/value pair
    # to the specific context in the spec/shared_contexts.rb file
    # Note: you can only use a single hiera context per describe/context block
    # rspec-puppet does not allow you to swap out hiera data on a per test block
    include_context :hiera


    # below is the facts hash that gives you the ability to mock
    # facts on a per describe/context block.  If you use a fact in your
    # manifest you should mock the facts below.
    # below is a list of the resource parameters that you can override
    # by default all non-required parameters are commented out
    # while all required parameters will require you to add a value

    # add these two lines in a single test block to enable puppet and hiera debug mode
    # Puppet::Util::Log.level = :debug
    # Puppet::Util::Log.newdestination(:console)
    describe 'RedHat' do
      let(:facts) do
        {:osfamily => 'RedHat'}
      end
      let(:params) do
        {
          :path => '/opt',
          :url => 'https://services.gradle.org/distributions',
          :version => '2.2.1',
          :flavour => 'bin',
        }
      end
      it do
        should contain_archive('gradle-2.2.1-bin.zip').
                 with({"path"=>"/opt/gradle-2.2.1-bin.zip", "source"=>"https://services.gradle.org/distributions/gradle-2.2.1-bin.zip",
                       "extract"=>"true", "extract_path"=>"/opt",
                       "creates"=>"/opt/gradle-2.2.1", "cleanup"=>"true"})
      end
      it { should contain_file('/usr/local/bin/gradle').
                    with({
                           :ensure => 'symlink',
                           :target => '/opt/gradle-2.2.1/bin/gradle',
                           :require => 'Archive[gradle-2.2.1-bin.zip]'
                         })}
    end

    describe 'windows' do
      let(:facts) do
        {:osfamily => 'windows'}
      end
      let(:params) do
        {
          :path => 'C:',
          :url => 'https://services.gradle.org/distributions',
          :version => '2.2.2',
          :flavour => 'bin',
        }
      end
      it do
        should contain_archive('gradle-2.2.2-bin.zip').
                 with({"path"=>"C:/gradle-2.2.2-bin.zip", "source"=>"https://services.gradle.org/distributions/gradle-2.2.2-bin.zip",
                       "extract"=>"true", "extract_path"=>"C:",
                       "creates"=>"C:/gradle-2.2.2", "cleanup"=>"true"})
      end
      it { should contain_windows_env('gradle_path').
            with({
                :ensure => 'present',
                :variable => 'Path',
                :value    => 'C:/gradle-2.2.2/bin',
                :require => 'Archive[gradle-2.2.2-bin.zip]'
           })}
    end

end
