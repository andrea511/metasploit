class Backup < Msf::Pro::MinimalBackup
  def self.generate(filename, description, overwrite: true, tee: nil, delay: false)
    archive = new(filename, overwrite: overwrite, tee: tee)
    if delay && archive.valid?
      archive.create_empty_zip(description)
      Backup.delay.generate(filename, description)
      archive
    elsif archive.errors.any?
      archive
    else
      if super
        backup_status = 'is complete'
      else
        backup_status = 'encountered an error'
      end

      Notifications::Message.create(
          title: 'Backup',
          content: "\"#{archive.name}\" #{backup_status}",
          url: '/settings#backups',
          kind: :system_notification
      )
    end
  end

  def self.restore_alternate(filepath, delay: false)
    archive = new(filepath)
    raise RuntimeError.new('Backup does not exist') unless archive.description
    raise RuntimeError.new('Backup is from a newer version of Metasploit') unless archive.compatible?

    archive.mark_restore_queued
    if delay
      Backup.delay.restore_alternate(filepath)
    else
      archive.restore_alternate
      Notifications::Message.create(
        title: "\"#{archive.name}\" restored",
        content: 'Please restart Metasploit.',
        url: '/settings#backups',
        kind: :system_notification
      )
    end

    archive
  end

  protected

  def self.rails_env
    Rails.env
  end
end
