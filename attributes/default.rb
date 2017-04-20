#
# Author::    Roland Moriz
# Cookbook::  moriz_duplicity
# Attributes:: default
#
# Copyright:: 2017, Moriz GmbH <info+github@moriz.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['duplicity']['packages'] = value_for_platform_family(
  debian: %w(
    duplicity
    lftp
    python-boto
    python-gdata
    python-cloudfiles
    python-paramiko
    python-pip
    python-swiftclient
    python-cffi
    rsync
    tahoe-lafs
  ),
  rhel: %w(
    duplicity
    lftp
    python2-pip
    python-devel
    openssl-devel
  )
)
