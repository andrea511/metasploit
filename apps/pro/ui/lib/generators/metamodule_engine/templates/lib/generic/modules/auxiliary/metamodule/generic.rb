#
# $Id$
##

##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/framework/
##

#
# Gems
#

require 'msf/core'

#
# Project
#

require Metasploit::Pro.root.join('engine/lib/pro/mixins/apps/helpers').to_path
require 'msf/pro/task'

class MetasploitModule < Msf::Auxiliary
  include Msf::Pro::Task
  include Msf::Auxiliary::Report
  include Msf::Pro::Apps::Helpers


  def initialize
    super(
        'Name'        => 'Module Name',
        'Description' => 'Module Description',
        'Author'      => 'John Doe',
        'License'     => 'Rapid7 Proprietary'
    )

    @command_mode = :single_threaded

    register_options([
                         OptString.new('APP_RUN_ID', [true,  'ID of the AppRun saved in the database.']),
                     ])
  end

  def run
    app_run.run!
    print_status "Running Module..."
    run_report if app_run_contains_report?
  end

  # Called by ProTask object that runs the show
  # @return[Notifications::Message]
  def completed_notification
    content = "Discovered hosts"
    Notifications::Message.create(default_notification_options.merge(
                                      :content => content
                                  ))
  end
end
