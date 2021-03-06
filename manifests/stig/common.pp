# % CMITS - Configuration Management for Information Technology Systems
# % Based on <https://github.com/afseo/cmits>.
# % Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
# %
# % Licensed under the Apache License, Version 2.0 (the "License");
# % you may not use this file except in compliance with the License.
# % You may obtain a copy of the License at
# %
# %    http://www.apache.org/licenses/LICENSE-2.0
# %
# % Unless required by applicable law or agreed to in writing, software
# % distributed under the License is distributed on an "AS IS" BASIS,
# % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# % See the License for the specific language governing permissions and
# % limitations under the License.
class apache::stig::common {
    include apache

# \implements{apachestig}{WA00530 A22}%
# Secure the web server PID file.
    file { "/var/run/httpd/httpd.pid":
        mode => '0644',
    }

# \implements{apachestig}{WG300 A22}%
# Fix permissions of Web server system files.
#
# Since we use Apache as shipped by Red Hat, and its files are not under
# \verb!/usr/local!, but in their proper places throughout the filesystem, not
# all the permission fixes are here. Also, we don't have a ``web user'': as the
# vendor recommends, we start Apache httpd as root, and then it drops all the
# privileges it doesn't need and becomes the apache user. This means the
# configuration files, private keys, etc. can be owned by root.

    file {
        "/etc/httpd":
            owner => root, group => 0, mode => '0600';
    }

# \verb!bin! permissions are taken care of by the packaging system, and
# verified in \S\ref{class_rpm::stig}.
#
# \verb!logs! permissions are covered under \S\ref{class_log::stig} and below.
#
# \verb!htdocs! permissions vary by web server. In the particular case of the
# AFSEO SBU website, see under \S\ref{module_sbu}.
#

# \implements{apachestig}{WG230 A22}%
# Prevent Web server administration or file uploads over Telnet, FTP, or rsh.
    include telnet::no
    include ftp::no
    include rsh::no

# \implements{apachestig}{WG250 A22}%
# Make sure root owns the web server log files. Permissions are taken care of
# by \S\ref{class_log::stig}.
    file { "/var/log/httpd":
        owner => root, group => 0,
        recurse => true, recurselimit => 2,
    }

# \implements{apachestig}{WG360 A22}%
# Get rid of symbolic links which are installed by default.
    file { "/var/www/icons/poweredby.png":
        ensure => absent,
    }
}
