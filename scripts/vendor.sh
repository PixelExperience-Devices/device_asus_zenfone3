#!/sbin/sh

# /sbin/sh runs out of TWRP.. use it.

PROGS="toybox"
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

# Check for /vendor existence
VENDOR=`ls -l /dev/block/by-name/ | ${TOYBOX} grep -c vendor`

if [ ${VENDOR} -ge 1 ] ; then
# Got it, we're done...
   ${TOYBOX} echo "/vendor partition found! "
   exit 0
fi

# Missing...
${TOYBOX} echo "/vendor partition missing! "
exit 1
