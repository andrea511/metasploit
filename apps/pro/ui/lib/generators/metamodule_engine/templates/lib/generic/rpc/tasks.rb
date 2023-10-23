module Pro
module RPC
module Stubs
module Tasks

  def rpc_start_<%= file_name %>_testing(conf={})
    _start_module_task(conf, "metamodule/<%= file_name %>", "<%= file_name %> Testing")
  end

end
end
end
end