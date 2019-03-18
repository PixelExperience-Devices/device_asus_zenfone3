#
# Copyright (C) 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := external/toybox

#
# To sync with upstream:
#

#  # Update.
#  git remote add toybox https://github.com/landley/toybox.git
#  git fetch toybox
#  git merge toybox/master

#  # Regenerate generated files.
#  make

#  # Make any necessary Android.mk changes and rebuild.
#  mm -j32

#  # Run tests.
#  ./run-tests-on-android.sh
#  # Run a single test.
#  ./run-tests-on-android.sh wc

#  # Upload changes.
#  git commit -a --amend
#  git push aosp HEAD:refs/for/master  # Push to gerrit for review.
#  git push aosp HEAD:master  # Push directly, avoiding gerrit.


#
# To add a toy:
#

#  Edit .config to enable the toy you want to add.
#  make clean && make  # Regenerate the generated files.
#  # Edit LOCAL_SRC_FILES below to add the toy.
#  # If you just want to use it as "toybox x" rather than "x", you can stop now.
#  # If you want this toy to have a symbolic link in /system/bin, add the toy to ALL_TOOLS.

common_SRC_FILES := \
    lib/args.c \
    lib/dirtree.c \
    lib/getmountlist.c \
    lib/help.c \
    lib/interestingtimes.c \
    lib/lib.c \
    lib/linestack.c \
    lib/llist.c \
    lib/net.c \
    lib/portability.c \
    lib/xwrap.c \
    main.c \
    toys/posix/echo.c \
    toys/posix/grep.c \
    toys/posix/sed.c \

common_CFLAGS := \
    -std=gnu11 \
    -Os \
    -Wall -Werror \
    -Wno-char-subscripts \
    -Wno-gnu-variable-sized-type-not-at-end \
    -Wno-missing-field-initializers \
    -Wno-sign-compare \
    -Wno-string-plus-int \
    -Wno-uninitialized \
    -Wno-unused-parameter \
    -funsigned-char \
    -ffunction-sections -fdata-sections \
    -fno-asynchronous-unwind-tables \

toybox_libraries := liblog libselinux libcutils libcrypto libz

common_CFLAGS += -DTOYBOX_VENDOR=\"-android\"

# not usable on Android?: freeramdisk fsfreeze install makedevs nbd-client
#                         partprobe pivot_root pwdx rev rfkill vconfig
# currently prefer BSD system/core/toolbox: dd
# currently prefer BSD external/netcat: nc netcat
# currently prefer external/efs2progs: blkid chattr lsattr

ALL_TOOLS := \
    echo \
    sed \
    grep \

############################################
# static version to be installed in recovery
############################################

include $(CLEAR_VARS)
LOCAL_MODULE := toybox_msm8953
LOCAL_SRC_FILES := $(common_SRC_FILES)
LOCAL_CFLAGS := $(common_CFLAGS)
LOCAL_STATIC_LIBRARIES := $(toybox_libraries)
# libc++_static is needed by static liblog
LOCAL_CXX_STL := libc++_static
LOCAL_MODULE_PATH := $(PRODUCT_OUT)/install/bin
LOCAL_FORCE_STATIC_EXECUTABLE := true
##LOCAL_POST_INSTALL_CMD := $(hide) $(foreach t,$(ALL_RECOVERY_TOOLS),ln -sf ${LOCAL_MODULE} $(LOCAL_MODULE_PATH)/$(t);)
include $(BUILD_EXECUTABLE)
