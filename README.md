# vmw
command line tool for grouping VMWare Workstation vms and spawning them on windows via the WSL

#### why?
Because I play vidya games and thus am stuck on windows a lot and the free version of vmware workstation doesn't allow you to create groups, spawn multiple vm's at once, etc.

#### why wsl?
cause cancer.

#### but no seriously, why?
don't judge me.

## How-to
Please note that you have to provide it a windows path to the executable for vmplayer.exe before spawning vms.

Also note that you have to provide a windows path to the folder associated with each group, ie: homelab, network, vulnhub, etc

Lastly, it currently only works with VMWare style VMs ie: C:\Path\to\folder\VMName\VMName.vmx - this is because it's passing the vmx file to the vmplayer.exe on the command line.

#### Git it.
```bash
git clone https://github.com/dostoevskylabs/vmw.git && cd vmw && chmod +x vmw.sh
```

#### Access it with just the command name
```bash
sudo ln -s ~/git/vmw/vmw.sh /usr/bin/vmw
```

#### Usage
```bash
dostoevsky@prototype:~$ vmw --help
  Commands
-=-=-=-=-=-=-
 --config 'path=C:/path/to/vmplayer.exe'
        define your path to the vmplayer.exe

 --add-group [group name] 'path=C:/path/to/virtual/machines'
        add a group to vmw pointing it to a folder containing machines for this group

 --delete-group [group name]
        delete a group ( this will not delete the machines in windows )

 --list-groups
        list all groups

 --list [group name]
        list a specific group's machines

 --list-all
        list all machines organized by group

 --spawn [group name]/[VM Name]
        spawn machine from a group

 --spawn-group [group name]
        spawn an entire group

 --help
        print this menu :-)
```

```bash
dostoevsky@prototype:~$ vmw --config "path=C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe"
 - Saved config: path=C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe to ~/.vmw/config
```

```bash
dostoevsky@prototype:~$ vmw --add-group HomeLab "path=C:\Users\dostoevsky\Documents\Virtual Machines"
 - Added group 'HomeLab' with config: path=C:\Users\dostoevsky\Documents\Virtual Machines
```

```bash
dostoevsky@prototype:~$ vmw --list-groups
 Groups
-=-=-=-=-
 HomeLab        (C:\Users\dostoevsky\Documents\Virtual Machines)
 Network        (C:\Users\dostoevsky\Documents\Networking Machines)
```

```bash
dostoevsky@prototype:~$ vmw --list HomeLab
 HomeLab
-=-=-=-=-
 - Kali
 - Ubuntu
```

```bash
dostoevsky@prototype:~$ vmw --list-all
 Group: HomeLab
-=-=-=-=-=-=-=-
 Kali
 Ubuntu

 Group: Network
-=-=-=-=-=-=-=-
 Gateway 1
 Gateway 2
```

```bash
dostoevsky@prototype:~$ vmw --spawn HomeLab/Kali
- Spawning Kali
```

```bash
dostoevsky@prototype:~$ vmw --spawn-group HomeLab
 - Spawning Kali
 - Spawning Ubuntu
```
