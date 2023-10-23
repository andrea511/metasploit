require 'msf/core'

module Msf
###
#
# This module provides shared methods for top-level Pro modules
#
###
module Pro
module MultiPost

  def spawn_post_threads(post_sessions, max_threads=5)
    threads = []
    while true do
      until post_sessions.empty? do
        max_threads.times do
          # Don't spawn new threads if we don't have more sessions
          break if post_sessions.empty?
          session_id = post_sessions.pop
          threads << framework.threads.spawn("PostExploitation Session: #{session_id}", false, session_id ) do |sid|
            process_session(sid)
          end
        end
      end

      # Exit once all our threads have completed
      break if threads.empty?
    end

  end

  def session_header
    "SESSION #{datastore['SESSION']} - #{client.session_host}:"
  end


end
end
end
