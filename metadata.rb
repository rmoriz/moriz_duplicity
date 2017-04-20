name             'moriz_duplicity'
maintainer       'Roland Moriz'
maintainer_email 'info+github@moriz.de'
license          'Apache-2.0'
description      'Installs/Configures duplicity'
long_description 'Installs/Configures duplicity'
source_url       '#' if respond_to?(:source_url)
issues_url       '#' if respond_to?(:issues_url)
version          '1.0.0'

depends          'build-essential'
depends          'compat_resource', '>= 12.19.0'
depends          'yum-epel'
depends          'apt'

chef_version '>= 12.1'

supports 'centos', '>= 6'
supports 'debian', '>= 7'
supports 'ubuntu', '>= 12.04'
