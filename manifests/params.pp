class gradle::params {
  $url = 'https://services.gradle.org/distributions'
  $version = '2.2.1'
  $flavour = 'bin'

  case $::osfamily {
    'RedHat': {
      $path = '/opt'
      $target = '/opt/gradle'
    }
    'Windows': {
      $path = 'C:/'
      $target = 'C:/gradle'
    }
  }
}
