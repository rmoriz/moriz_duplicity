#
# Author::    Roland Moriz
# Cookbook::  moriz_duplicity
# Resources:: duplicity
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

resource_name :duplicity
default_action :install

property :name,                String, name_attribute: true
property :installation_method, String, default: 'package'

property :enable_ppa,        [true, false], default: false
property :enable_backports,  [true, false], default: false
property :enable_azure,      [true, false], default: true
property :enable_dropbox,    [true, false], default: true

property :python_bin,        String, default: '/usr/bin/python'
property :pip_bin,           String, default: '/usr/bin/pip'

action :install do
  add_backports if enable_backports
  add_ppa       if enable_ppa

  case installation_method
  when 'source'
    install_from_source
  when 'package'
    install_from_package
  else
    raise 'No installation method selected for duplicity. Either set `source` or `package` to true'
  end

  return unless enable_azure || enable_dropbox

  prepare_python

  install_pip('azure')   if enable_azure
  install_pip('dropbox') if enable_dropbox
end

action_class.class_eval do
  def install_from_package
    package node['duplicity']['packages']
  end

  def install_from_source
    # TODO
    raise 'Sorry, installation_method "source" is not yet implemented :('
  end

  def add_ppa
    return unless node['platform'] == 'ubuntu'

    apt_repository 'duplicity-ppa' do
      uri 'http://ppa.launchpad.net/duplicity-team/ppa/ubuntu'
      distribution node['lsb']['codename']
      components ['main']
      keyserver 'keyserver.ubuntu.com'
      key '7A86F4A2'
    end

    # The package python-swiftclient is not available on Ubuntu < 12.10.
    # It's available in OpenStacks Folsom stable PPA, though
    apt_repository 'openstack-ppa' do
      uri 'http://ppa.launchpad.net/openstack-ubuntu-testing/folsom-stable-testing/ubuntu'
      distribution node['lsb']['codename']
      components ['main']
      keyserver 'keyserver.ubuntu.com'
      key '3B6F61A6'
      only_if { node['platform'] == 'ubuntu' && node['platform_version'].to_f < 12.10 }
    end
  end

  def add_backports
    return unless node['platform'] == 'debian'

    backports_resource_name = "#{node['lsb']['codename']}-backports"

    find_resource(:apt_repository, backports_resource_name) do
      uri 'https://deb.debian.org/debian'
      distribution backports_resource_name
      components ['main']
      cache_rebuild true
      action :add
    end
  end

  def install_pip(pip_name)
    execute "install pip #{pip_name}" do
      command "#{pip_bin} install #{pip_name}"
      not_if "#{pip_bin} list --format=legacy | grep \"^#{pip_name}\""
    end
  end

  def prepare_python
    # many pips need build essentials so let's install it early:
    include_recipe 'build-essential'

    case node['platform_family']
    when 'debian'
      # Debian 8, Ubuntu Trusty and earlier
      execute 'update pbr pip' do
        command "#{pip_bin} install --upgrade pbr"
        only_if "#{pip_bin} list | grep \"^pbr\s(0\.\""
      end

      execute 'upgrade broken pip' do
        command 'easy_install pip'
        not_if "#{pip_bin} list | grep pip"
      end
    end
  end
end
