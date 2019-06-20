# == Class: radarr::service
#
class radarr::service (
  $service_enable = $radarr::service_enable,
  $service_name   = $radarr::service_name,
  $user           = $radarr::user,
  $group          = $radarr::user,
  $install_path   = $radarr::install_path,
  $executable     = $radarr::executable,
  $base_path      = $radarr::base_path,
) {
  if $service_enable {
    include ::systemd

    systemd::unit_file { "${service_name}.service":
      content => template('radarr/systemd.erb'),
      enable  => true,
      active  => true,
    }
  }
}
