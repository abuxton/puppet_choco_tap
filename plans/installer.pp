plan puppet_choco_tap::installer(
  TargetSpec                                   $nodes,
  String                                       $package,
  Variant[Enum['absent', 'present'], String ]  $ensure = 'present',
){

  apply_prep($nodes)

  apply($nodes){
    include chocolatey
  }
  apply($nodes){
    package { $package :
      ensure    => $ensure,
      provider  => 'chocolatey',
    }
  }
}
