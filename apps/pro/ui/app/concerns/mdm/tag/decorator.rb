module Mdm::Tag::Decorator
  extend ActiveSupport::Concern

  included do
    #
    # Callbacks
    #
    before_validation :format_name, :on => :create
  end

  def h_crlf_desc
    return nil if desc.nil?
    desc.split(/\r?\n/).map { |line| h(line) }.join("<br/>")
  end

  # Used to sort by importance of the tag -- criticals should be at the top.
  def importance
    i = 0
    i = i | 1 if report_detail
    i = i | 2 if report_summary
    i = i | 4 if critical
    i
  end

  def reportability
    text = []
    text << "Critical finding" if self.critical
    text << "include in host details" if self.report_detail
    text << "include in report summary" if self.report_summary
    if text.empty?
      return "Do not report"
    else
      text[0] = text[0].capitalize
      return text.join(", ")
    end
  end

  def to_a
    [self.name, self.desc]
  end

  def to_s
    self.name
  end

  # Tags are created once and updated several times.
  def updated?
    self.created_at != self.updated_at
  end

  private

  # remove whitespace and single-quotes from name
  def format_name
    self.name = self.name.gsub("'", "").to_s.strip.lstrip.gsub(/\s+/,"_")
  end
end
