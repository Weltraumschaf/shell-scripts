#!/usr/bin/env bash 
# useradd.sh v1.2
# (cc) 2006 Filipp Lepalaan <filipp@mac.com>
# Updated to support both Tiger & Leopard <filipp@mac.com>
# Updated for Leopard by Allan Sanderson <allanbee@mac.com>
# Included non-interactive password setting - this is a contencious issue for
# many, but it fits with what I need it to do!

usage="sudo $(basename $0) [-u uid] [-g group] [-a] [-c] [-d home] \
  [-p passwd] [-s shell] [-rn realname] name"

if [ $# -eq 0 ]
	then echo "Usage: $usage" >&2;
	exit 1
fi

# Thnx to pea!
if [ $USER != "root" ]
	then echo "$(basename $0) must be run as root" >&2
	exit 1
fi

# Some defaults
def_shell=$SHELL
def_home='/Users'
make_home=true
make_admin=false
set_home=false
make_passwd=true
def_passwd=$(cat -n /usr/share/dict/words | grep -w $(jot -r 1 1 $n) | cut -f2)

nextid() {
  max_id=$(dscl . -list $1 $2 | awk '{print $2}' | sort -n | tail -n 1)
  (( max_id++ ))
  echo $max_id
}

new_uid=$(nextid /Users UniqueID)
new_gid=$(nextid /Groups PrimaryGroupID)

os_ver=$(sysctl -n kern.osrelease);os_ver=${os_ver:0:1}

while getopts "u:g:acd:p:s:rn:" param
do
	case $param in
		u ) new_uid=${OPTARG:-$new_uid};;
		g ) new_gid=${OPTARG:-$new_gid};;
		a ) make_admin=true;;
		c ) make_home=true;;
		d ) set_home=true; new_home=${OPTARG:-$new_user};;
		p ) new_passwd=${OPTARG:-$def_passwd};;
		s ) new_shell=${OPTARG:-$def_shell};;
		rn ) new_fn=${OPTARG:-$def_rn};;
	esac
done

shift $(($# - 1)); new_user=$1 # Get the last argument

# Check if user already exists
dscl . -read /Users/$new_user &> /dev/null
if [ $? -eq 0 ]
  then echo "Error: user $new_user already exists" >&2
	exit 1
fi

# Set to default if not given
new_rn=${new_fn:-$new_user}
new_shell=${new_shell:-$def_shell}
new_passwd=${new_passwd:-"$def_passwd"}
new_home=${new_home:-"$def_home/$new_user"}

# Process user record
dscl . -create /Users/$new_user UniqueID $new_uid
dscl . -create /Users/$new_user RealName "$new_rn"
dscl . -create /Users/$new_user UserShell $new_shell
dscl . -create /Users/$new_user GeneratedUID $(uuidgen)
dscl . -create /Users/$new_user PrimaryGroupID $new_gid

# Process group record
if [ $os_ver -lt 9 ]
  then dscl . -create /Groups/$new_user PrimaryGroupID $new_gid
  dscl . -create /Groups/$new_user GroupMembership $new_user
fi

# Create home directory
if [ $make_home == true ]
	then echo "Creating $new_home"
  cp -r /System/Library/User\ Template/English.lproj/ $new_home
  cp -r /System/Library/User\ Template/Non_localized/* $new_home/
	chown -R $new_user:$new_gid $new_home
	set_home=true	# Otherwise this'd be pretty pointless
fi

if [ $set_home == true ]
	then dscl . -create /Users/$new_user NFSHomeDirectory $new_home
fi

if [ $make_admin == true ]
	then echo "Adminning $new_user"
	dscl . -append /Groups/admin users $new_user
fi

if [ $make_passwd == true ]
	then echo "Setting password for $new_user"
	dscl . -passwd /Users/$new_user "$new_passwd"
fi

echo "User $new_user ($new_uid) created, password: $new_passwd"

exit 0
