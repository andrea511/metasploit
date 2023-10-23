module SocialEngineering
  class SentEmailsTable < Struct.new(:records)
    def as_json(options={})
      {}
    end
  end
end
