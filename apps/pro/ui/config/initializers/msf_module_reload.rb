#
# Preload the module tree and ensure ProSvc is happy and running
#
Rails.application.configure do
  config.after_initialize do
    if Rails.env.production? and ! ENV['MSFRPC_SKIP']
      prosvc_running = false
      connection_cnt = 0
      until prosvc_running
        begin
          # Wrap this in a timeout to prevent a hung reply from hanging this
          ::Timeout.timeout(20) do
            MsfModule.all
            prosvc_running = true
          end
        rescue ::Exception
          select(nil, nil, nil, 3)
          connection_cnt += 1
        end

        # If its been 50 seconds, go ahead and exit
        break if connection_cnt > 10
      end
    end

    # Clear the cached data for modules
    MsfModule.reload_modules
  end
end
