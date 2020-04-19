#!/bin/bash -x

# For the workshop, we need to be prepared for 3 possibilities
#   root disk is specified by UUID
#   root disk is a LVM
#   root disk is a block device
#
# This logic appears to work until proven otherwise

echo "Determining root device..."

eval $(grep -o '\broot=[^ ]*' /proc/cmdline)

echo "UUID reduction if necessary..."

if [[ "${root}" =~ ^UUID=(.*) ]] ; then 
  rootdev=`blkid -U ${BASH_REMATCH[1]}`
else
  rootdev="${root}"
fi

echo "Creating GRUB2 entry..."

if /usr/sbin/lvs -q ${rootdev} ; then 
  boom create --title "Alt Kernel Parms" --rootlv ${rootdev}
else
  boom create --title "Alt Kernel Parms" --root-device ${rootdev}
fi
