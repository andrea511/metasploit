module TransactionHandler
  # This method wraps a block in a retry if we get a RecordNotUnique validation error.
  # This helps guard against race conditions.
  def retry_transaction(&block)
    tries = 3
    begin
      yield
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      tries -= 1
      if tries > 0
        retry
      else
        raise
      end
    end
  end
end