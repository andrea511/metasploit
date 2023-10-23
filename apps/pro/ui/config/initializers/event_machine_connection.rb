#
# Monkey-patch a typo still present in the latest EventMachine gem
#
module EventMachine
  class Connection
    def associate_callback_target(sig)
      # Nothing
    end
  end
end
