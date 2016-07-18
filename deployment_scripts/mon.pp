include osnailyfacter::ceph::mon

# Workaround for https://bugs.launchpad.net/fuel/+bug/1603409
Service<| title == 'cinder-volume' or title == 'cinder-backup' or title == 'glance-api' |> {
  noop => true,
}
