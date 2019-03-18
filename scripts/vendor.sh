#!/sbin/sh

# /sbin/sh runs out of TWRP.. use it.

PROGS="sgdisk toybox"
RC=0
# Check for my needed programs
for PROG in ${PROGS} ; do
   if [ ! -x "/tmp/${PROG}" ] ; then
      echo "Missing: /tmp/${PROG}"
      RC=9
   fi
done
#
# all prebuilt
if [ ${RC} -ne 0 ] ; then
   echo "Aborting.."
   exit 7
fi
TOYBOX="/tmp/toybox"

# Get bootdevice.. don't assume /dev/block/sda
# Dont remove 0 from mmcblk0p, assume system's number is two digit

DISK=`${TOYBOX} readlink /dev/block/bootdevice/by-name/system | ${TOYBOX} sed -e's/p[0-9][0-9]//g'`

# Check for /vendor existence
VENDOR=`/tmp/sgdisk --pretend --print ${DISK} | ${TOYBOX} grep -c vendor`

if [ ${VENDOR} -ge 1 ] ; then
# Got it, we're done...
   ${TOYBOX} echo "/vendor partition found! "
   exit 0
fi

# Missing...
${TOYBOX} echo "/vendor partition missing! "
exit 1
