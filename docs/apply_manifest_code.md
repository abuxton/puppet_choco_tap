# Applying Manifest Code With Bolt


In this exercise you will further explore Puppet Plans by using the `apply` keyword to leverage existing content from the [Puppet Forge](https://forge.puppet.com/).

You can read more about using bolt `apply` in Masterless Workflows in a [Blog Post](https://puppet.com/blog/introducing-masterless-puppet-bolt) written by Bolt developer Michael Smith. 

You will deploy two web servers and a load balancer to distribute the traffic evenly between them with the following steps:
1. Build a project specific configuration using a `Boltdir`.
2. Download useful module content from the Puppet forge. 
3. Write a Puppet Plan to `apply` puppet code to install the additional resource provider for the Puppet Package resource using Chocolatey. 
4. Write a Bolt Plan to `apply` puppet code and orchestrate the deployment of a Package resource using the Chocolatey provider. 

# Prerequisites

For the following exercises you will want to provision a windows node with Powershell and WinRM access.



# Build a Boltdir

By default `$HOME/.puppetlabs/bolt/` is the base directory for user-supplied data such as the configuration and inventory files. It is effectively the default `Boltdir`. 
You may find it useful to maintain a project specific `Boltdir`. When you commit a `Boltdir` to a project you can share Bolt configuration and code between users.
You can also maintain each module as it's own `Boltdir` this is useful for testing and development.

Bolt will search for a `Boltdir` in parent directories of the directory from which it was run.

## Inventory

Build an inventory to organize provisioned nodes. This will be the first configuration file in our new project specific `Boltdir`. 

**Note**: Example outputs are for a classroom environment in AWS, and are in the modules `inventory.yaml` file.


Make sure your inventory is configured correctly and you can connect to all nodes. Run from within the project Boltdir:

```bash
bolt command run 'echo hi' -n win
```
Expected output
```
Started on x.x.x.x...
Started on localhost...
Started on 127.0.0.1...
Finished on localhost:
  STDOUT:
    hi
Finished on 0.0.0.0:
  STDOUT:
    hi
Finished on 127.0.0.1:
  STDOUT:
    hi
Successful on 3 nodes: 0.0.0.0:20022,127.0.0.1,localhost
Ran on 3 nodes in 0.20 seconds

```

## Module Content

In order to install module content from the forge Bolt uses a `Puppetfile`. See [Puppetfile Documentation](https://puppet.com/docs/pe/latest/puppetfile.html) for more information. 

Save the following `Puppetfile` that describes the Puppet Forge content to be installed in the project `Boltdir`. 

**note**
Becouse we are using our module in our bolt project we also reference our own module, this maintains it's sharability and keeps the working environment clean.

```
forge 'https://forge.puppet.com'

# Modules from the Puppet Forge
mod 'puppetlabs-chocolatey', '4.1.0'
## dependancies
mod 'puppetlabs-stdlib'#, '4.13.1' #install latest
mod 'puppetlabs-powershell', '2.3.0'
mod 'puppetlabs-registry', '2.1.0'

# Modules from Git
# Examples: https://github.com/puppetlabs/r10k/blob/master/doc/puppetfile.mkd#examples
#mod 'apache',
#  :git    => 'https://github.com/puppetlabs/puppetlabs-apache',
#  :commit => 'de290646f97e04b4b8e42c70f6e01e860c394ce7'

mod 'puppet_choco_tap',
    :git    =>  'https://github.com/abuxton/puppet_choco_tap.git' 
```

From within the `Boltdir` install the Forge content with the following Bolt command:
```
bolt puppetfile install
```
Confirm that a `modules` directory has been created in the project `Boltdir`. 

## Write profile module

Now that you have downloaded existing modules it is time to execute the plan from with our own module content. 

Take note of the following features of the plan:

1. This plan has three parameters, the `nodes` TargetSpec, a `package` String for Package name, and the `ensure` state of the package which allows for version, absent or present. 
2. Notice the `apply_prep` function call. `apply_prep` is used to install packages needed by apply on remote nodes as well as to gather facts about the nodes.
3. The first apply block installs Chocolatey package manager. The chocolatey provider is also deployed as a library with the Puppet agent in  `apply_prep`.
4. The second apply block installs the package using the chocolatey provider


```puppet
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
```

Verify the `puppet_chocolatey_tap` plan is available to run using `bolt plan show`. You should see an output similar to: 
```

facts
facts::info
puppet_choco_tap::installer
puppetdb_fact
```

Now you are ready to execute the plan. 

`bolt plan run puppet_choco_tap::installer package=<name> --nodes=win --password`

Expected output
```
Starting: plan puppet_choco_tap::installer
Starting: install puppet and gather facts on chocowin0.classroom.puppet.com, chocowin1.classroom.puppet.com
Finished: install puppet and gather facts with 0 failures in 22.11 sec
Starting: apply catalog on chocowin0.classroom.puppet.com, chocowin1.classroom.puppet.com
Finished: apply catalog with 0 failures in 18.77 sec
Starting: apply catalog on chocowin0.classroom.puppet.com, chocowin1.classroom.puppet.com
Finished: apply catalog with 0 failures in 33.74 sec
Finished: plan puppet_choco_tap::installer in 74.63 sec
```

In order to verify the deployment is operating as expected use the following `frogsay` commands to see the output.

command: `bolt command run 'frogsay ribbit' --nodes win --password`

We expect the result to vary on each server as `ribbit` is a random print.
```
Started on chocowin1.classroom.puppet.com...
Started on chocowin0.classroom.puppet.com...
Finished on chocowin0.classroom.puppet.com:
  STDOUT:
    
            DO NOT PAINT OVER FROG.
            /
      @..@
     (----)
    ( >__< )
    ^^ ~~ ^^
Finished on chocowin1.classroom.puppet.com:
  STDOUT:
    
            TO PREVENT THE RISK OF FIRE OR ELECTRIC SHOCK, DO NOT ENGAGE WITH FROG
            WHILE AUTOMATIC UPDATES ARE BEING INSTALLED.
            /
      @..@
     (----)
    ( >__< )
    ^^ ~~ ^^
Successful on 2 nodes: chocowin0.classroom.puppet.com,chocowin1.classroom.puppet.com
Ran on 2 nodes in 3.15 seconds

```


# Next steps

Now that you have learned about applying existing module content you can harness the power of the Puppet forge to manage infrastructure and deploy great applications!

