module Mdm::Tag::Hosts
  def add_host_by_id(hid)
    begin
      h = Mdm::Host.find(hid)
    rescue
      @errors = "Invalid Mdm::Host id: #{h hid}."
      return
    end
    self.hosts = (self.hosts | [h]).uniq
  end
end