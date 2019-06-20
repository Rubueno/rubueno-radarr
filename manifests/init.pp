# == Class: radarr
#
class radarr (
  $manage_epel         = $radarr::params::manage_epel,
  $install_mono        = $radarr::params::install_mono,
  $mono_baseurl        = $radarr::params::mono_baseurl,
  $mono_gpgkey         = $radarr::params::mono_gpgkey,
  $mono_packages       = $radarr::params::mono_packages,
  $additional_packages = $radarr::params::additional_packages,
  $user                = $radarr::params::user,
  $group               = $radarr::params::user,
  $base_path           = $radarr::params::base_path,
  $install_path        = $radarr::params::install_path,
  $config_folder       = $radarr::params::config_folder,
  $app_folder          = $radarr::params::app_folder,
  $archive_name        = $radarr::params::archive_name,
  $archive_url         = $radarr::params::archive_url,
  $executable          = $radarr::params::executable,
  $service_enable      = $radarr::params::service_enable,
  $service_name        = $radarr::params::service_name,
) inherits radarr::params {

  contain radarr::install
  contain radarr::service

  Class['radarr::install'] ~>
  Class['radarr::service']
}
