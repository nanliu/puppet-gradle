class params {
  $url = 'https://services.gradle.org/distributions'
  $version = '1.12'
  $flavour = 'bin'

  case $::osfamily {
    'RedHat': {
      $path = '/opt'
      $target = '/opt/gradle'
    }
    'Windows': {
      $path = 'C:/'
      $target = 'C:\\gradle'
    }
  }
}
