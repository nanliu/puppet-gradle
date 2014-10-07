# Installs gradle
class gradle (
  $path    = $gradle::params::path,
  $url     = $gradle::params::url,
  $version = $gradle::params::version,
  $flavour = $gradle::params::flavour,
) inherits gradle::params {

  validate_re($flavour, ['^all$', '^bin$', '^src$'])

  $filename = "gradle-${version}-${flavour}.zip"
  $gradle_path = "${path}/gradle-${version}"

  archive { $filename:
    path         => $path,
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
      exec { 'ensure gradle in path':
        command  => "[Environment]::SetEnvironmentVariable('Path', \$env:Path + '${gradle_path}\\bin;', [EnvironmentVariableTarget]::Machine)",
        unless   => "\$(\$env:Path).ToLower().Contains(\$('${gradle_path}\\bin').ToLower())",
        provider => 'powershell',
      }
    }
  }
}
