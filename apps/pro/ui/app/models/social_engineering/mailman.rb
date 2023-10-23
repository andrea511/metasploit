#
# Responsible for preparing all parts of an Email message for sending
# through SMTP.
#
# Basically in charge of: 
#  * "mail merge" w/ Target List (addressing per human target on the list)
#  * processing of template/content through Liquid
#  * doing non-exploit attachments
#  * creating queue of processed messages ready to be sent
#

require 'rex/mime'
require 'rex/zip'
module SocialEngineering
class Mailman

  attr_reader :email

  def initialize(email_id)
    @email = Email.retrieve_for_process(email_id).first # gets template, targets, all at once
  end


  # Sets up one fully-qualified MIME message for a given human target
  def processed_message_for_human_target(human_target:, attach_campaign_files: true)
    msg = Rex::MIME::Message.new
    msg.mime_defaults

    # Set headers
    msg.header.set("Content-Type", content_type_header_string(msg))

    # Set addressing/subject
    msg.to      = message_recipient_string(human_target)
    msg.from    = "#{email.from_name} <#{email.from_address}>"
    msg.subject = email.subject

    # Set body
    msg.add_part(email.render_body_for_send(human_target), "text/html; charset=UTF-8")

    # Set attachments
    email.files.inject(msg) do |the_msg, file|
      # Let send_email.rb attach the campaign file(s)
      unless (file.is_a?(SocialEngineering::CampaignFile) && attach_campaign_files == false)
        add_attachment_to_message_and_return_message(file, the_msg)
      end
    end

    msg
  end

  # Add a CampaignFile's file data to a MIME message w/ the given content disposition
  def add_attachment_to_message_and_return_message(campaign_file, msg)

    # Handle CampaignFile or File objects
    case campaign_file
    when SocialEngineering::CampaignFile
      file        = campaign_file.attachment
      file_name   = email.attachment_file_name
      extname     = File.extname(file.current_path).sub(".", "")
      disposition = campaign_file.content_disposition

      if extname == "exe"
        content_type = "application/octet-stream"
      end

    # MSF-generated file -- assume it's an exploit
    when File
      file      = campaign_file
      file_name = email.attachment_file_name
      extname   = File.extname(file).sub(".", "")
      content_type = "application/octet-stream"
    else
      raise ArgumentError, "campaign_file must be of class SocialEngineering::CampaignFile or File"
    end

    # Set the content type as a MIME string if we haven't set it above
    content_type ||= mime_string_from_extension(extname)

    # Default to attachment if not set from CampaignFile
    disposition ||= "attachment"

    # Get the actual file data
    if @email.zip_attachment? == true 
      data = zip_attachment(file, file_name)
      content_type = "application/zip"
      basename = ::File.basename(file_name, ::File.extname(file_name))
      file_name = "#{basename}.zip"
    else
      data = file.read
    end

    part = msg.add_part(Rex::Text.encode_base64(data), content_type, "BASE64")
    part.header.set("Content-Disposition", "#{disposition}; filename=\"#{file_name}\"")

    if disposition == "inline"
      part.header.set("Content-ID", "<#{campaign_file.content_id}>")
    end

    msg
  end

  def zip_attachment(file, name)
    zip = ::Rex::Zip::Archive.new
    zip.add_file(name, file.read)
    zip.pack
  end

  def mime_string_from_extension(ext)
    Mime::Type.lookup_by_extension(ext).to_s
  end

  # Returns "Content-Type" string for the message
  def content_type_header_string(msg)
    "multipart/related;\r\n\tboundary=\"#{msg.bound}\";\r\n\ttype=\"text/html\""
  end

  # Create the "to" string for the message
  def message_recipient_string(human_target)
    "\"#{human_target.first_name} #{human_target.last_name}\" <#{human_target.email_address}>" 
  end

end
end
