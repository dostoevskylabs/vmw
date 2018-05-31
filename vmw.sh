#!/bin/bash
if [ ! -d ~/.vmw ]; then
        mkdir ~/.vmw
fi

if [ ! -d ~/.vmw/groups ]; then
        mkdir ~/.vmw/groups
fi

if [ ! -f ~/.vmw/config ]; then
        touch ~/.vmw/config
fi

help () {
        echo "  Commands "
        echo "-=-=-=-=-=-=-"
        echo " --config 'path=C:/path/to/vmplayer.exe'"
        echo "  define your path to the vmplayer.exe"
        echo ""
        echo " --add-group      [group name] 'path=C:/path/to/virtual/machines'"
        echo "  add a group to vmw pointing it to a folder containing machines for this group"
        echo ""
        echo " --delete-group   [group name]"
        echo "  delete a group ( this will not delete the machines in windows )"
        echo ""
        echo " --list-groups"
        echo "  list all groups"
        echo ""
        echo " --list   [group name]"
        echo "  list a specific group's machines"
        echo ""
        echo " --list-all"
        echo "  list all machines organized by group"
        echo ""
        echo " --spawn  [group name]/[VM Name]"
        echo "  spawn machine from a group"
        echo ""
        echo " --spawn-group    [group name]"
        echo "  spawn an entire group"
        echo ""
        echo " --help"
        echo "  print this menu :-)"
}


while [[ $# -gt 0 ]]
do
case $1 in
        -c|--config)
                if [ -z "$2" ]; then
                        echo ' ! Invalid config'
                        exit 1
                fi
                echo "$2" > ~/.vmw/config
                echo " - Saved config: $2 to ~/.vmw/config"
                exit 1
        ;;
        -ag|--add-group)
                if [ -z "$2" ]; then
                        echo ' ! Invalid group name'
                        exit 1
                fi

                if [ -d ~/.vmw/groups/$2 ]; then
                        echo " ! Group '$2' already exists"
                        exit 1
                fi

                if [ -z "$3" ]; then
                        echo ' ! Invalid group config'
                        exit 1
                fi

                mkdir ~/.vmw/groups/$2
                echo "$3" > ~/.vmw/groups/$2/config

                echo " - Added group '$2' with config: $3"
                exit 1
        ;;
        -dg|--delete-group)
                if [ -z "$2" ]; then
                        echo ' ! Invalid group'
                        exit 1
                fi

                if [ ! -d ~/.vmw/groups/$2 ]; then
                        echo ' ! Invalid group'
                        exit 1
                fi

                rm -rf ~/.vmw/groups/$2
                echo " - Removed group '$2'"
                exit 1
        ;;
        -lg|--list-groups)
                echo " Groups"
                echo "-=-=-=-=-"
                for a in $(ls ~/.vmw/groups);
                do
                        vmpath=$(cat ~/.vmw/groups/$a/config | cut -d= -f2);
                        echo " $a       ($vmpath)"

                done
                exit 1
        ;;
        -l|--list)
                if [ -z "$2" ]; then
                        echo ' ! Invalid group'
                        exit 1
                fi

                if [ ! -d ~/.vmw/groups/$2 ]; then
                        echo ' ! Invalid Group'
                        exit 1
                fi

                echo " $2"
                echo "-=-=-=-=-"

                vmpath=$(cat ~/.vmw/groups/$2/config | cut -d= -f2);
                vmpath2=$(echo "/mnt/${vmpath,}" | sed -e 's/://' | sed -e 's/\\/\//g');
                if [ ! -d "$vmpath2" ]; then
                        echo ' ! Invalid group config'
                        echo ""
                else
                        for a in $(ls "$vmpath2");
                        do
                                echo " - $a"
                        done
                fi
                exit 1
        ;;
        -la|--list-all)
                for a in $(ls ~/.vmw/groups);
                do
                        echo " Group: $a"
                        echo "-=-=-=-=-=-=-=-"
                        vmpath=$(cat ~/.vmw/groups/$a/config | cut -d= -f2);
                        vmpath2=$(echo "/mnt/${vmpath,}" | sed -e 's/://' | sed -e 's/\\/\//g');
                        if [ ! -d "$vmpath2" ]; then
                                echo ' ! Invalid group config'
                                echo ""
                        else
                                for b in $(ls "$vmpath2");
                                do
                                        echo " $b"
                                done
                                echo ""
                        fi
                done
                exit 1
        ;;
        -s|--spawn)
                path=$(cat ~/.vmw/config | cut -d= -f2);
                path2=$(echo "/mnt/${path,}" | sed -e 's/://' | sed -e 's/\\/\//g');
                group=$(echo $2 | cut -d/ -f1);

                if [ ! -d ~/.vmw/groups/$group ]; then
                        echo ' ! Group does not exist'
                        exit 1
                fi

                vm=$(echo $2 | cut -d/ -f2);
                vmpath=$(cat ~/.vmw/groups/$group/config | cut -d= -f2);
                vmpath2=$(echo "/mnt/${vmpath,}" | sed -e 's/://' | sed -e 's/\\/\//g');

                if [ ! -f "$path2" ]; then
                        echo ' ! Add the path to your vmplayer.exe with the command'
                        echo 'eg: --config "path=C:\path\to\vmplayer.exe"'
                        exit 1
                fi

                if [ ! -d "$vmpath2" ]; then
                        echo ' ! Path for group is invalid'
                        exit 1
                fi

                if [ ! -f "$vmpath2/$vm/$vm.vmx" ]; then
                        echo " ! $vm Does not exist"
                        exit 1
                fi

                echo "- Spawning $vm"

                "$path2" "$vmpath/$vm/$vm.vmx" 2>/dev/null
                exit 1
        ;;
        -sg|--spawn-group)
                path=$(cat ~/.vmw/config | cut -d= -f2);
                path2=$(echo "/mnt/${path,}" | sed -e 's/://' | sed -e 's/\\/\//g');

                if [ ! -d ~/.vmw/groups/$2 ]; then
                        echo " ! Group does not exist"
                        exit 1
                fi

                vmpath=$(cat ~/.vmw/groups/$2/config | cut -d= -f2);
                vmpath2=$(echo "/mnt/${vmpath,}" | sed -e 's/://' | sed -e 's/\\/\//g');

                if [ ! -f "$path2" ]; then
                        echo ' ! Add the path to your vmplayer.exe with the command'
                        echo 'eg: --config "path=C:\path\to\vmplayer.exe"'
                        exit 1
                fi

                if [ ! -d "$vmpath2" ]; then
                        echo ' ! Path for group is invalid'
                        echo ""
                fi

                for a in $(ls "$vmpath2");
                do
                        vm=$a
                        if [ ! -f "$vmpath2/$vm/$vm.vmx" ]; then
                                echo " ! $vm Does not exist"
                                echo ""
                        else
                                echo " - Spawning $vm"
                                echo ""
                                "$path2" "$vmpath/$vm/$vm.vmx" 2>/dev/null
                        fi
                done
                exit 1
        ;;
        -h|--help|*)
                help
                exit 1
        ;;
esac
done

help
