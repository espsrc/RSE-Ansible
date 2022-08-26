# RSE-Ansible
 
# Rucio RSE based on StoRM-webdav with OIDC token Authentication
How to add a Rucio RSE using a puppet StoRM and WebDav deployment with OIDC A&A tokens using Ansible (IaC)


## Requirements
* VM or container with CentOS7.
* 4 GB RAM and 4 CPU cores.
* 50 GB of SSD or another storage technology connected.
* Storage system connected and configured in the vm and mounted in specific folder
* Ansible Control Node or a host with Ansible installed on it and ready for managing remote hosts.
* Add a storage mount point (or a folder that points out) for /storage/dteam/disk/

## Use Ansible

You can install a released version of Ansible with pip or a package manager. See our [installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for details on installing Ansible on a variety of platforms.

Power users and developers can run the devel branch, which has the latest features and fixes, directly. Although it is reasonably stable, you are more likely to encounter 
breaking changes when running the devel branch. We recommend getting involved in the Ansible community if you want to run the devel branch.

## Clone Repo
The first step is to clone the repository on the machine that has ansible installed.
```bash
git clone https://github.com/spsrc/RSE-Ansible.git
```

## Configuring Inventory File
You need to add the target host in the inventorie
```bash
vi inventories/list
```
Go to [centos7] tag  and enter the ip and port for your target host
```bash
[centos7]
<IP> ansible_ssh_port=<port>
```

## Other Configurations
You need to change your password in ~/files/setup.pp
**'supersecretpassword'**, 
```python
# install bdii
class { 'bdii':
  firewall   => false,
  bdiipasswd => 'supersecretpassword', # avoid service reloading at each run of Puppet agent
}
```
In ~/files/manifest.pp
```
class { 'storm::backend':
  db_username           => 'storm',
  db_password           => 'storm',
  ...
  xmlrpc_security_token => 'NS4kYAZuR65XJCq',
  ...
class { 'storm::frontend':
  be_xmlrpc_host  => $host,
  be_xmlrpc_token => 'NS4kYAZuR65XJCq',
  db_user         => 'storm',
  db_passwd       => 'storm',
}
```
Now is time to edit the following file ~/files/application.yml to set-up the credentials A&A.
* client-id: **From escape**
* client-secret: **From escape**
```
        registration:
          escape:
            provider: escape
            client-name: ska-storm-webdav
            client-id: 
            client-secret: 
            scope:
              - openid
              - profile
              - wlcg.groups
```
## To Run Playbook
```bash
ansible-playbook -i inventories/list rucio_rse_client.yml
```

Check StoRM status:
```
systemctl status storm-webdav
```
Check that the WebDav service responds
```
curl http://localhost:8085/actuator/health
{"status":"DOWN"}
```
If you see {"status":"DOWN"}, check the logs to know what is going on:
```
cat /var/log/storm/webdav/storm-webdav-server.log
```

Get service metrics
```
curl http://localhost:8085/status/metrics?pretty=true
```
It will return:
```
{
  "version" : "4.0.0",
  "gauges" : {
    "jvm.gc.G1-Old-Generation.count" : {
      "value" : 0
    },
    "jvm.gc.G1-Old-Generation.time" : {
      "value" : 0
    }
    ...
}
```
Start the StoRM WebDav
```
systemctl start storm-webdav
```
Check the status
```
systemctl status storm-webdav
```
Check the service logs here:
```
tail /var/log/storm/webdav/storm-webdav-server.log
```
