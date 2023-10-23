module Pro
class Client
    def start_<%= file_name %>_testing(conf)
      call("pro.start_<%= file_name %>_testing", conf)
    end
end
end