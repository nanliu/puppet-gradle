require_relative 'spec/fixtures/modules/helper/lib/bodeco_module_helper/vagrant'

vm(
  :hostname => 'gradle',
  :module   => 'gradle',
  :memory   => 2048,
  :box      => 'oracle65-pe3.2.3'
)
vm(
  :hostname => 'windows',
  :module => 'gradle',
  :type => :windows,
  :memory => 4096,
  :cpu => 2,
  :box => 'win2008r2',
  :gui => true
)