module Mdm::Listener::Task
  def active?
    self.task and self.task.running?
  end

  def restart
    start
  end

  def start
    stop

    return if not self.enabled

    c = Pro::Client.get
    t = c.start_listener(
        'workspace'      => self.workspace.name,
        'username'       => self.owner,
        'DS_LISTENER_ID' => self[:id]
    )

    if t and t['task_id']
      self.task = Mdm::Task.find( t['task_id'] )
    end

    self.save if self.changed?
    self.task
  end

  def stop
    if active?
      self.task.rpc_stop
      self.task = nil
      self.save
    end
  end
end
