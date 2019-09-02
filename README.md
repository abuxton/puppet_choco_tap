
# puppet Chocolatey Task and Plans

Using the learnings from Puppet Bolt Task and Plans lab (https://github.com/puppetlabs/tasks-hands-on-lab) impliment demonstration of Puppet Aplly task to install chocolatey, and use the puppet package provider to install packages as part fop a Puppet Bolt Plan.

#### Table of Contents

- [puppet Chocolatey Task and Plans](#puppet-chocolatey-task-and-plans)
      - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [Setup Requirements **OPTIONAL**](#setup-requirements-optional)
    - [Beginning with puppet_choco_tap](#beginning-with-puppetchocotap)
  - [Usage](#usage)
  - [Limitations](#limitations)

## Description

Utilize the following modules and their dependencies 
* https://forge.puppet.com/chocolatey/chocolatey
* https://forge.puppet.com/puppetlabs/chocolatey

to create a task to install Chocolatey and the required Puppet Package provider, and use it in a demonstratable workflow to install Windows packages.

## Setup




### Setup Requirements **OPTIONAL**

Install Bolt and create project folder as documented

* https://puppet.com/docs/bolt/latest/bolt_installing.html
* https://puppet.com/docs/bolt/latest/bolt_configuration_options.html
* https://puppet.com/docs/bolt/latest/inventory_file.html

### Beginning with puppet_choco_tap

 Clone the module to a host OS with Bolt installed, review available tasks and plans.

* cd ./modulefolder
* bolt plan show --modulepath=./
* bolt task show --modulepath=./

## Usage

<TODO>


## Limitations

Only tested against Windows Powershell, and not any other Powershell deployment

