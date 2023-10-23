module SocialEngineering
  class CampaignDetails < Struct.new(:campaign)
    include ActiveSupport::Inflector

    def current_status
      humanize(campaign.state)
    end

    def email_count
      campaign.emails.count
    end

    def web_page_count
      campaign.web_pages.count
    end

    def portable_files_count
      campaign.portable_files.count
    end

    def email_targets_count
      campaign.emails.to_a.sum do |email|
        if email.target_list.present? && email.target_list.human_targets.present?
          email.target_list_remaining.count
        else
          0
        end
      end
    end

    def started_at
      if campaign.started_at.present?
        format_date(campaign.started_at)
      else
        'not started'
      end
    end

    def startable?
      campaign.startable?
    end

    def updated_at
      format_date(campaign.updated_at)
    end

    def to_hash
      {
        current_status: current_status,
        email_count: email_count,
        web_page_count: web_page_count,
        email_targets_count: email_targets_count,
        started_at: started_at,
        evidence_collected: 0,
        portable_files_count: portable_files_count,
        name: campaign.name,
        startable: startable?,
        updated_at: updated_at
      }
    end

    private

    def format_date(date)
      date.strftime('%B %-e, %Y at %-l:%M %p')
    end
  end
end
