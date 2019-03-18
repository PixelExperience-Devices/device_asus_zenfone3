#
# Copyright (C) 2018 The LineageOS Project
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

import hashlib
import common
import re

def FullOTA_Assertions(info):
  AddModemAssertion(info, info.input_zip)
  AddVendorAssertion(info)
  return

def IncrementalOTA_Assertions(info):
  AddModemAssertion(info, info.target_zip)
  AddVendorAssertion(info)
  return

def AddModemAssertion(info, input_zip):
  android_info = input_zip.read("OTA/android-info.txt")
  m = re.search(r'require\s+version-modem\s*=\s*(.+)', android_info)
  if m:
    version = m.group(1).rstrip()
    if len(version) and '*' not in version:
      info.script.AppendExtra(('assert(zenfone3.verify_modem("%s") == "1");' % (version)))
  return

def AddVendorAssertion(info):
  info.script.AppendExtra('package_extract_file("install/bin/sgdisk_msm8953", "/tmp/sgdisk");');
  info.script.AppendExtra('package_extract_file("install/bin/toybox_msm8953", "/tmp/toybox");');
  info.script.AppendExtra('package_extract_file("install/bin/vendor.sh", "/tmp/vendor.sh");');
  info.script.AppendExtra('set_metadata("/tmp/sgdisk", "uid", 0, "gid", 0, "mode", 0755);');
  info.script.AppendExtra('set_metadata("/tmp/toybox", "uid", 0, "gid", 0, "mode", 0755);');
  info.script.AppendExtra('set_metadata("/tmp/vendor.sh", "uid", 0, "gid", 0, "mode", 0755);');
  info.script.AppendExtra('ui_print("Checking for vendor partition...");');
  info.script.AppendExtra('if run_program("/tmp/vendor.sh") != 0 then');
  info.script.AppendExtra('abort("Flash Treble TWRP and enable treble first!");');
  info.script.AppendExtra('endif;');

