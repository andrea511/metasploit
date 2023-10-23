module SocialEngineering::TargetListsHelper

  def generate_csv(target_list=@target_list)
    CSV.generate do |csv|
      csv << SocialEngineering::TargetList::VALID_CSV_IMPORT_FILE_HEADERS_FORMAT.map(&:to_s)
      @target_list.human_targets.each { |target|
        csv << target.build_csv_row
      }
    end
  end
end