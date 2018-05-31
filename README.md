# vmw
command line tool for grouping VMWare Workstation vms and spawning them on windows via the WSL

## Example
```bash
dostoevsky@prototype:~$ ./vmw.sh --help
  Commands
-=-=-=-=-=-=-
 --config       'path=C:/path/to/vmplayer.exe'
	define your path to the vmplayer.exe
 --add-group    [group name] 'path=C:/path/to/virtual/machines'
	add a group to vmw pointing it to a folder containing machines for this group
 --delete-group [group name]
	delete a group ( this will not delete the machines in windows )
 --list-groups
	list all groups
 --list 		[group name]
	list a specific group's machines
 --list-all
	list all machines organized by group
 --spawn        [group name]/[VM Name]
	spawn machine from a group
 --spawn-group  [group name]
	spawn an entire group
 --help
	print this menu
```

```bash
dostoevsky@prototype:~$ ./vmw.sh --config "path=C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe"
 - Saved config: path=C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe to ~/.vmw/config
```

```bash
dostoevsky@prototype:~$ ./vmw.sh --add-group HomeLab "C:\Users\dostoevsky\Documents\Virtual Machines"
 - Added group 'HomeLab' with config: C:\Users\dostoevsky\Documents\Virtual Machines
```

```bash
dostoevsky@prototype:~$ ./vmw.sh --list-groups
 Groups
-=-=-=-=-
 HomeLab        (C:\Users\dostoevsky\Documents\Virtual Machines)
 Network        (C:\Users\dostoevsky\Documents\Networking Machines)
```

```bash
dostoevsky@prototype:~$ ./vmw.sh --list HomeLab
 HomeLab
-=-=-=-=-
 - Kali
 - Ubuntu
```

```bash
dostoevsky@prototype:~$ ./vmw.sh --list-all
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
dostoevsky@prototype:~$ ./vmw.sh --spawn HomeLab/Kali
- Spawning Kali
```

```bash
dostoevsky@prototype:~$ ./vmw.sh --spawn-group HomeLab
 - Spawning Kali
 - Spawning Ubuntu
```
