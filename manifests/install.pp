# == Class: radarr::install
#
class radarr::install (
  $manage_epel         = $radarr::manage_epel,
  $install_mono        = $radarr::install_mono,
  $mono_baseurl        = $radarr::mono_baseurl,
  $mono_gpgkey         = $radarr::mono_gpgkey,
  $mono_packages       = $radarr::mono_packages,
  $additional_packages = $radarr::additional_packages,
  $user                = $radarr::user,
  $group               = $radarr::user,
  $base_path           = $radarr::base_path,
  $install_path        = $radarr::install_path,
  $config_folder       = $radarr::config_folder,
  $app_folder          = $radarr::app_folder,
  $archive_name        = $radarr::archive_name,
  $archive_url         = $radarr::archive_url,
  $executable          = $radarr::executable,
) {

  if $manage_epel {
    package { 'epel-release':
      ensure => 'installed',
    }
  }

  if $install_mono {
    yumrepo { 'mono':
      ensure   => present,
      baseurl  => $mono_baseurl,
      gpgkey   => $mono_gpgkey,
      gpgcheck => true,
    } ->

    package { $mono_packages:
      ensure => installed,
    }
  }

  $_additional_packages = $additional_packages ? {
    Array   => true,
    default => false,
  }

  if $_additional_packages {
    package { $additional_packages:
      ensure => installed,
    }
  }

  group { $group:
    ensure => present,
  }

  user { $user:
    ensure     => present,
    shell      => '/sbin/nologin',
    groups     => $group,
    managehome => true,
  }

  file { [ $base_path, $install_path, $config_folder, $app_folder ]:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  $_archive_url = strip(generate('/bin/sh', '-c', "${archive_url}"))

  archive { $archive_name:
    path         => "/tmp/${archive_name}",
    source       => "${_archive_url}",
    extract      => true,
    extract_path => $install_path,
    creates      => "${install_path}/${executable}",
    cleanup      => true,
    require      => File[$install_path],
    user         => $user,
    group        => $group,
  } ->
  exec { 'move radarr files to correct folder':
    command => "/usr/bin/mv ${install_path}/Radarr/* ${install_path}",
    creates => "${install_path}/${executable}",
  }
}
