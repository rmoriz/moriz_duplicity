#
# Author::    Roland Moriz
# Cookbook::  duplicity
# Resources:: test/smoke/package/backend_spec.rb
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
#

# Backends and their URL formats:
#   cf+http://container_name
#   file:///some_dir
#   ftp://user[:password]@other.host[:port]/some_dir
#   ftps://user[:password]@other.host[:port]/some_dir
#   hsi://user[:password]@other.host[:port]/some_dir
#   imap://user[:password]@other.host[:port]/some_dir
#   rsync://user[:password]@other.host[:port]::/module/some_dir
#   rsync://user[:password]@other.host[:port]/relative_path
#   rsync://user[:password]@other.host[:port]//absolute_path
#   s3://other.host/bucket_name[/prefix]
#   s3+http://bucket_name[/prefix]
#   scp://user[:password]@other.host[:port]/some_dir
#   ssh://user[:password]@other.host[:port]/some_dir
#   swift://container_name
#   tahoe://alias/directory
#   webdav://user[:password]@other.host/some_dir
#   webdavs://user[:password]@other.host/some_dir
#   gdocs://user[:password]@other.host/some_dir
#   pydrive://user@other.host/some_dir
#   mega://user[:password]@other.host/some_dir
#   copy://user[:password]@other.host/some_dir
#   dpbx:///some_dir
#   onedrive://some_dir
#   azure://container_name
#   b2://account_id[:application_key]@bucket_name/[some_dir/]

# boto/s3
describe command('timeout 3 duplicity --name boto --dry-run /tmp s3://other.host/bucket_name') do
  its('stderr') { should_not match /BackendException: Could not initialize backend: No module named boto/ }
end

# swift
describe command('timeout 3 duplicity --name swift --dry-run /tmp swift://container_name') do
  its('stderr') { should_not match /BackendException: This backend requires the python-swiftclient library/ }
end

# tahoe
describe command('timeout 3 duplicity --name tahoe --dry-run /tmp tahoe://alias/directory') do
  its('stdout') { should_not match /pkg_resources.DistributionNotFound/ }
end

# lftp
describe command('timeout 3 duplicity --name lftp --dry-run /tmp ftp://localhost') do
  its('stderr') { should_not match /LFTP not found/ }
end

# azure
describe command('timeout 3 duplicity --name azure --dry-run /tmp azure://container_name') do
  its('stderr') { should_not match /Azure backend requires Microsoft Azure Storage SDK for Python/ }
end

# dropbox
describe command('timeout 3 duplicity --name dpbx --dry-run /tmp dpbx://some_dir') do
  its('stderr') { should_not match /BackendException: Could not initialize backend/ }
end
