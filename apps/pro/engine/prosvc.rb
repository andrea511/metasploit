#!/usr/bin/env ruby

#
# Standard Library
#

require 'pathname'

#
# Project
#

# @see https://github.com/rails/rails/blob/v3.2.17/railties/lib/rails/generators/rails/app/templates/script/rails#L3-L5
require Pathname.new(__FILE__).expand_path.parent.join('config', 'boot')
require 'metasploit/pro/engine/command/service'

Metasploit::Pro::Engine::Command::Service.start
