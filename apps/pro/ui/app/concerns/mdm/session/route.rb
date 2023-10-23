module Mdm::Session::Route
  def add_route
    c = Pro::Client.get

    begin
      Timeout.timeout(10) do
        # Delete the route first, if it exists
        unless routes.where({:subnet => "0.0.0.0", :netmask => "0.0.0.0"}).first.blank?
          c.call('session.meterpreter_script', local_id.to_s, "autoroute -s 0.0.0.0/0 -d")
          c.call('session.meterpreter_read', local_id.to_s)
        end

        # (Re)Create the route.
        c.call('session.meterpreter_script', local_id.to_s, "autoroute -s 0.0.0.0/0")
        # Continue to read until we get the expected output
        buff = ''
        while(r = c.call('session.meterpreter_read', local_id.to_s))
          buff << r['data'] if (r and r['data'])
          route_cmd_result = buff
          if route_cmd_result.index("Added route")
            break
          else
            select(nil, nil, nil, 0.25)
          end
        end
      end
    rescue ::Timeout::Error
      return false
    end

    return true
  end

  def del_route
    c = Pro::Client.get

    begin
      Timeout.timeout(10) do
        c.call('session.meterpreter_script', local_id.to_s, "autoroute -s 0.0.0.0/0 -d")
        # Continue to read until we get the expected output
        buff = ''
        while(r = c.call('session.meterpreter_read', local_id.to_s))
          buff << r['data'] if (r and r['data'])
          route_cmd_result = buff
          if route_cmd_result.index("Deleted")
            break
          else
            select(nil,nil,nil,0.25)
          end
        end
      end
    rescue ::Timeout::Error
      return false
    end

    return true
  end
end