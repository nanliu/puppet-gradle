# Installs gradle
class gradle (
  $path    = $gradle::params::path,
  $url     = $gradle::params::url,
  $version = $gradle::params::version,
  $flavour = $gradle::params::flavour,
) inherits gradle::params {

  validate_re($flavour, ['^all$', '^bin$', '^src$'])
  validate_string($path)

  $filename = "gradle-${version}-${flavour}.zip"
  $gradle_path = "${path}/gradle-${version}"

  archive { $filename:
    path         => "${path}/${filename}",
    source       => "${url}/${filename}",
    extract      => true,
    extract_path => $path,
    creates      => $gradle_path,
    cleanup      => true,
  }

  case $::osfamily {
    'RedHat': {
      file { '/usr/local/bin/gradle':
        ensure  => symlink,
        target  => "${gradle_path}/bin/gradle",
        require => Archive[$filename],
      }
    }

    'Windows': {
      windows_env{'gradle_path':
        ensure => present,
        variable => 'Path',
        value    => "${gradle_path}/bin",
        require  =>  Archive[$filename],
      }
    }
  }
}
