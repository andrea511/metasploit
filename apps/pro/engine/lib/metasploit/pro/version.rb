module Metasploit::Pro
  class Version

    def self.version
      info['version']
    end

    def self.revision
      info['revision']
    end

    def self.date
      info['date']
    end

    def self.footer_revision
      info['footer_revision'] || revision
    end

    def self.info
      @info ||= begin
        spath = File.join(File.dirname(__FILE__), '..', '..', '..', 'version.yml')
        yaml = YAML.load(::File.read(spath)) rescue {}
        info = yaml.inject({}) do |h, (key, val)|
          h[key.to_s] = val.to_s
          h
        end
        info['date'] = Date.parse(info['date']) rescue nil if info['date']
        info
      end
    end
  end
end
