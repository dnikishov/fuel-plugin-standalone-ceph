notice('MODULAR: standalone-ceph/ceph-mon-hiera-override.pp')

$plugin_name     = 'standalone-ceph'
$plugin_metadata = hiera($plugin_name, false)
$hiera_dir       = '/etc/hiera/plugins'
$plugin_yaml     = "${plugin_name}.yaml"

$role            = 'standalone-ceph-mon'
$primary_role    = 'primary-standalone-ceph-mon'
$plugin_roles    = [$primary_role, $role]

$current_roles   = hiera('roles')

$network_metadata 	     	  = hiera_hash('network_metadata')
$ceph_primary_monitor_node 	  = get_nodes_hash_by_roles($network_metadata, ['primary-standalone-ceph-mon'])
$ceph_monitor_nodes 		  = get_nodes_hash_by_roles($network_metadata, ['primary-standalone-ceph-mon','standalone-ceph-mon'])


if !empty(intersection($current_roles, $plugin_roles)) {
  $corosync_roles = $plugin_roles
} else {
  $corosync_roles = []
}


file { '/etc/hiera':
  ensure  => directory,
}

file { $hiera_dir:
  ensure   => directory,
  require  => File['/etc/hiera'],
}

file { "${hiera_dir}/${plugin_yaml}":
  ensure   => file,
  content  => template("${plugin_name}/${plugin_yaml}.erb"),
  require  => File[$hiera_dir],
}
