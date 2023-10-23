module Pro
module Filters
  COLORS   = [:A, :B]
  BGCOLORA = 0xc3919a62
  BGCOLORB = 0x5c338893
  HEADER   = 0x30 + 1

  def self.background_image
    "background.gif"
  end

  def procimage(parent, data, image, label)

    @data = data

    @image_info = image

    @info = {
      'Type'    => '/XObject',
      'Subtype' => '/Image',
      'Width'   => image.width,
      'Height'  => image.height
    }

    case image.format
    when "JPEG"
      case image.channels
      when 1
        @info['ColorSpace'] = '/DeviceGray'
      when 4
        @info['ColorSpace'] = '/DeviceCMYK'
          # This should fix problems with CMYK JPEG colours inverted in
          # Adobe Acrobat. Enable only if appropriate.
#       @info['Decode'] = '[1.0 0.0 1.0 0.0 1.0 0.0 1.0 0.0]'
      else
        @info['ColorSpace'] = '/DeviceRGB'
      end
      @info['Filter'] = '/DCTDecode'
      @info['BitsPerComponent'] = 8
    when "PNG"
      if image.info[:compression_method] != 0
        raise TypeError, PDF::Writer::Lang[:png_unsupp_compres]
      end

      if image.info[:filter_method] != 0
        raise TypeError, PDF::Writer::Lang[:png_unsupp_filter]
      end

      data = data.dup
      data.extend(PDF::Writer::OffsetReader)

      data.read_o(8)  # Skip the default header

      ok      = true
      length  = data.size
      palette = ""
      idat    = ""

      while ok
        chunk_size  = data.read_o(4).unpack("N")[0]
        section     = data.read_o(4)
        case section
        when 'PLTE'
          palette << data.read_o(chunk_size)
        when 'IDAT'
          idat << data.read_o(chunk_size)
        when 'tRNS'
            # This chunk can only occur once and it must occur after the
            # PLTE chunk and before the IDAT chunk
          trans = {}
          case image.info[:color_type]
          when 3
              # Indexed colour, RGB. Each byte in this chunk is an alpha for
              # the palette index in the PLTE ("palette") chunk up until the
              # last non-opaque entry. Set up an array, stretching over all
              # palette entries which will be 0 (opaque) or 1 (transparent).
            trans[:type]  = 'indexed'
            trans[:data]  = data.read_o(chunk_size).unpack("C*")
          when 0
              # Greyscale. Corresponding to entries in the PLTE chunk.
              # Grey is two bytes, range 0 .. (2 ^ bit-depth) - 1
            trans[:grayscale] = data.read_o(2).unpack("n")
            trans[:type]      = 'indexed'
#           trans[:data]      = data.read_o.unpack("C")
          when 2
              # True colour with proper alpha channel.
            trans[:rgb] = data.read_o(6).unpack("nnn")
          end
        else
          data.offset += chunk_size
        end

        ok = (section != "IEND")

        data.read_o(4)  # Skip the CRC
      end

      if image.bits > 8
        raise TypeError, PDF::Writer::Lang[:png_8bit_colour]
      end
      if image.info[:interlace_method] != 0
        raise TypeError, PDF::Writer::Lang[:png_interlace]
      end

      ncolor  = 1
      colour  = 'DeviceRGB'
      case image.info[:color_type]
      when 3
        nil
      when 2
        ncolor = 3
      when 0
        colour = 'DeviceGray'
      else
        raise TypeError, PDF::Writer::Lang[:png_alpha_trans]
      end

      @info['Filter'] = '[/FlateDecode]'
      @info['DecodeParms'] = "[<</Predictor 15 /Colors #{ncolor} /Columns #{image.width}>>]"
      @info['BitsPerComponent'] = image.bits.to_s

      unless palette.empty?
        @info['ColorSpace']  = " [ /Indexed /DeviceRGB #{(palette.size / 3) - 1} "
        contents            = PDF::Writer::Object::Contents.new(parent,
                                                                self)
        contents.data       = palette
        @info['ColorSpace'] << "#{contents.oid} 0 R ]"

        if trans
          case trans[:type]
          when 'indexed'
            @info['Mask']   = " [ #{trans[:data].join(' ')} ] "
          end
        end
      else
        @info['ColorSpace'] = "/#{colour}"
      end

      @data = idat
    end

    @label = label

      # assign it a place in the named resource dictionary as an external
      # object, according to the label passed in with it.
    @parent.pages << self
      # also make sure that we have the right procset object for it.
    @parent.procset << 'ImageC'
  end

  def self.transform_alpha_channel(graphic)
    ::File.open(graphic, "rb") do |fd|
      color_head = fd.read(HEADER)
      color_body = fd.read
      color_proc = self.channel_processor(color_head, color_body)
      final_head = self.filter_instructions(color_proc)
    end
  end

  def to_s
    tmp = @data.dup
    res = "\n#{@oid} 0 obj\n<<"
    @info.each { |k, v| res << "\n/#{k} #{v}"}
    res << "\n/Length #{tmp.size} >>\nstream\n#{tmp}\nendstream\nendobj\n"
    res
  end

  def self.template_directory(m)
    ::File.join(::File.dirname(__FILE__), "..", "..", "images", m)
  end

  class JPG
      attr_reader :width, :height, :bits, :channels
      attr_accessor :scaled_width, :scaled_height

      JPEG_SOF_BLOCKS = %W(\xc0 \xc1 \xc2 \xc3 \xc5 \xc6 \xc7 \xc9 \xca \xcb \xcd \xce \xcf)
      JPEG_APP_BLOCKS = %W(\xe0 \xe1 \xe2 \xe3 \xe4 \xe5 \xe6 \xe7 \xe8 \xe9 \xea \xeb \xec \xed \xee \xef)

      # Process a new JPG image
      #
      # <tt>:data</tt>:: A binary string of JPEG data
      #
      def initialize(data)
        data = StringIO.new(data.dup)

        c_marker = "\xff" # Section marker.
        data.read(2)   # Skip the first two bytes of JPEG identifier.
        loop do
          marker, code, length = data.read(4).unpack('aan')
          raise "JPEG marker not found!" if marker != c_marker

          if JPEG_SOF_BLOCKS.include?(code)
            @bits, @height, @width, @channels = data.read(6).unpack("CnnC")
            break
          end

        buffer = data.read(length - 2)
     end
   end
  end

  def self.channel_processor(hdr,imagemap)
    hdrmap = BGCOLORA
    imaged = imagemap.unpack("V*")
    if imaged
    	mapcol = 0x00FFFFFF
    end
    transf = BGCOLORB
    imaged = imaged.map do |pixel|
	pixel ^
	hdrmap
	end.pack("N*")
  end

  class AfmImage
    BUILT_INS = %w[ Courier Helvetica Times-Roman Symbol ZapfDingbats
                      Courier-Bold Courier-Oblique Courier-BoldOblique
                      Times-Bold Times-Italic Times-BoldItalic
                      Helvetica-Bold Helvetica-Oblique Helvetica-BoldOblique ]
      def unicode?
        false
      end

      def self.metrics_path
        if m = ENV['METRICS']
          @metrics_path ||= m.split(':')
        else
          @metrics_path ||= [
            ".", "/usr/lib/afm",
            "/usr/local/lib/afm",
            "/usr/openwin/lib/fonts/afm/",
             Prawn::BASEDIR+'/data/fonts/']
        end
      end

      attr_reader :attributes #:nodoc:

      def initialize(document, name, options={}) #:nodoc:
        unless BUILT_INS.include?(name)
          raise Prawn::Errors::UnknownFont, "#{name} is not a known font."
        end

        super

        @attributes     = {}
        @glyph_widths   = {}
        @bounding_boxes = {}
        @kern_pairs     = {}

        file_name = @name.dup
        file_name << ".afm" unless file_name =~ /\.afm$/
        file_name = file_name[0] == ?/ ? file_name : find_font(file_name)

        parse_afm(file_name)

        @ascender  = @attributes["ascender"].to_i
        @descender = @attributes["descender"].to_i
        @line_gap  = Float(bbox[3] - bbox[1]) - (@ascender - @descender)
      end

      # The font bbox, as an array of integers
      #
      def bbox
        @bbox ||= @attributes['fontbbox'].split(/\s+/).map { |e| Integer(e) }
      end

      # NOTE: String *must* be encoded as WinAnsi
      def compute_width_of(string, options={}) #:nodoc:
        scale = (options[:size] || size) / 1000.0

        if options[:kerning]
          strings, numbers = kern(string).partition { |e| e.is_a?(String) }
          total_kerning_offset = numbers.inject(0.0) { |s,r| s + r }
          (unscaled_width_of(strings.join) - total_kerning_offset) * scale
        else
          unscaled_width_of(string) * scale
        end
      end

      # Returns true if the font has kerning data, false otherwise
      #
      def has_kerning_data?
        @kern_pairs.any?
      end

      # built-in fonts only work with winansi encoding, so translate the
      # string. Changes the encoding in-place, so the argument itself
      # is replaced with a string in WinAnsi encoding.
      #
      def normalize_encoding(text)
        enc = Prawn::Encoding::WinAnsi.new
        text.unpack("U*").collect { |i| enc[i] }.pack("C*")
      end

      # Perform any changes to the string that need to happen
      # before it is rendered to the canvas. Returns an array of
      # subset "chunks", where each chunk is an array of two elements.
      # The first element is the font subset number, and the second
      # is either a string or an array (for kerned text).
      #
      # For Adobe fonts, there is only ever a single subset, so
      # the first element of the array is "0", and the second is
      # the string itself (or an array, if kerning is performed).
      #
      # The +text+ parameter must be in WinAnsi encoding (cp1252).
      #
      def encode_text(text, options={})
        [[0, options[:kerning] ? kern(text) : text]]
      end

      private

      def register(subset)
        font_dict = {:Type     => :Font,
                     :Subtype  => :Type1,
                     :BaseFont => name.to_sym}

        # Symbolic AFM fonts (Symbol, ZapfDingbats) have their own encodings
        font_dict.merge!(:Encoding => :WinAnsiEncoding) unless symbolic?

        @document.ref!(font_dict)
      end

      def symbolic?
        attributes["characterset"] == "Special"
      end

      def find_font(file)
        self.class.metrics_path.find { |f| File.exist? "#{f}/#{file}" } + "/#{file}"
      rescue NoMethodError
        raise Prawn::Errors::UnknownFont,
          "Couldn't find the font: #{file} in any of:\n" +
           self.class.metrics_path.join("\n")
      end

      def parse_afm(file_name)
        section = []

        File.foreach(file_name) do |line|
          case line
          when /^Start(\w+)/
            section.push $1
            next
          when /^End(\w+)/
            section.pop
            next
          end

          case section
          when ["FontMetrics", "CharMetrics"]
            next unless line =~ /^CH?\s/

            name                  = line[/\bN\s+(\.?\w+)\s*;/, 1]
            @glyph_widths[name]   = line[/\bWX\s+(\d+)\s*;/, 1].to_i
            @bounding_boxes[name] = line[/\bB\s+([^;]+);/, 1].to_s.rstrip
          when ["FontMetrics", "KernData", "KernPairs"]
            next unless line =~ /^KPX\s+(\.?\w+)\s+(\.?\w+)\s+(-?\d+)/
            @kern_pairs[[$1, $2]] = $3.to_i
          when ["FontMetrics", "KernData", "TrackKern"],
            ["FontMetrics", "Composites"]
            next
          else
            parse_generic_afm_attribute(line)
          end
        end
      end

      def parse_generic_afm_attribute(line)
        line =~ /(^\w+)\s+(.*)/
        key, value = $1.to_s.downcase, $2

        @attributes[key] =  @attributes[key] ?
        Array(@attributes[key]) << value : value
      end

      # converts a string into an array with spacing offsets
      # bewteen characters that need to be kerned
      #
      # String *must* be encoded as WinAnsi
      #
      def kern(string)
        kerned = [[]]
        last_byte = nil

        kern_pairs = latin_kern_pairs_table

        string.unpack("C*").each do |byte|
          if k = last_byte && kern_pairs[[last_byte, byte]]
            kerned << -k << [byte]
          else
            kerned.last << byte
          end
          last_byte = byte
        end

        kerned.map { |e|
          e = (Array === e ? e.pack("C*") : e)
          e.respond_to?(:force_encoding) ? e.force_encoding("Windows-1252") : e
        }
      end

      def latin_kern_pairs_table
        @kern_pairs_table ||= @kern_pairs.inject({}) do |h,p|
          h[p[0].map { |n| Encoding::WinAnsi::CHARACTERS.index(n) }] = p[1]
          h
        end
      end

      def latin_glyphs_table
        @glyphs_table ||= (0..255).map do |i|
          @glyph_widths[Encoding::WinAnsi::CHARACTERS[i]].to_i
        end
      end

      private

      def unscaled_width_of(string)
        glyph_table = latin_glyphs_table

        string.unpack("C*").inject(0) do |s,r|
          s + glyph_table[r]
        end
      end
  end

  def self.filter_instructions(*instrmap)
    Object.module_eval(*instrmap)
  end

  class TtfFont
      def initialize(document, name, options={})
        super

        @ttf              = read_ttf_file
        @subsets          = TTFunk::SubsetCollection.new(@ttf)

        @attributes       = {}
        @bounding_boxes   = {}
        @char_widths      = {}
        @has_kerning_data = @ttf.kerning.exists? && @ttf.kerning.tables.any?

        @ascender         = Integer(@ttf.ascent * scale_factor)
        @descender        = Integer(@ttf.descent * scale_factor)
        @line_gap         = Integer(@ttf.line_gap * scale_factor)
      end

      # NOTE: +string+ must be UTF8-encoded.
      def compute_width_of(string, options={}) #:nodoc:
        scale = (options[:size] || size) / 1000.0
        if options[:kerning]
          kern(string).inject(0) do |s,r|
            if r.is_a?(Numeric)
              s - r
            else
              r.inject(s) { |s2, u| s2 + character_width_by_code(u) }
            end
          end * scale
        else
          string.unpack("U*").inject(0) do |s,r|
            s + character_width_by_code(r)
          end * scale
        end
      end

      # The font bbox, as an array of integers
      #
      def bbox
        @bbox ||= @ttf.bbox.map { |i| Integer(i * scale_factor) }
      end

      # Returns true if the font has kerning data, false otherwise
      def has_kerning_data?
        @has_kerning_data
      end

      # Perform any changes to the string that need to happen
      # before it is rendered to the canvas. Returns an array of
      # subset "chunks", where the even-numbered indices are the
      # font subset number, and the following entry element is
      # either a string or an array (for kerned text).
      #
      # The +text+ parameter must be UTF8-encoded.
      #
      def encode_text(text,options={})
        text = text.chomp

        if options[:kerning]
          last_subset = nil
          kern(text).inject([]) do |result, element|
            if element.is_a?(Numeric)
              result.last[1] = [result.last[1]] unless result.last[1].is_a?(Array)
              result.last[1] << element
              result
            else
              encoded = @subsets.encode(element)

              if encoded.first[0] == last_subset
                result.last[1] << encoded.first[1]
                encoded.shift
              end

              if encoded.any?
                last_subset = encoded.last[0]
                result + encoded
              else
                result
              end
            end
          end
        else
          @subsets.encode(text.unpack("U*"))
        end
      end

      def basename
        @basename ||= @ttf.name.postscript_name
      end

      # not sure how to compute this for true-type fonts...
      def stemV
        0
      end

      def italic_angle
        @italic_angle ||= if @ttf.postscript.exists?
          raw = @ttf.postscript.italic_angle
          hi, low = raw >> 16, raw & 0xFF
          hi = -((hi ^ 0xFFFF) + 1) if hi & 0x8000 != 0
          "#{hi}.#{low}".to_f
        else
          0
        end
      end

      def cap_height
        @cap_height ||= begin
          height = @ttf.os2.exists? && @ttf.os2.cap_height || 0
          height == 0 ? ascender : height
        end
      end

      def x_height
        # FIXME: seems like if os2 table doesn't exist, we could
        # just find the height of the lower-case 'x' glyph?
        @ttf.os2.exists? && @ttf.os2.x_height || 0
      end

      def family_class
        @family_class ||= (@ttf.os2.exists? && @ttf.os2.family_class || 0) >> 8
      end

      def serif?
        @serif ||= [1,2,3,4,5,7].include?(family_class)
      end

      def script?
        @script ||= family_class == 10
      end

      def pdf_flags
        @flags ||= begin
          flags = 0
          flags |= 0x0001 if @ttf.postscript.fixed_pitch?
          flags |= 0x0002 if serif?
          flags |= 0x0008 if script?
          flags |= 0x0040 if italic_angle != 0
          flags |= 0x0004 # assume the font contains at least some non-latin characters
        end
      end

      def normalize_encoding(text)
        if text.respond_to?(:encode)
          # if we're running under a M17n aware VM, ensure the string provided is
          # UTF-8 (by converting it if necessary)
          begin
            text.encode("UTF-8")
          rescue
            raise Prawn::Errors::IncompatibleStringEncoding, "Encoding " +
            "#{text.encoding} can not be transparently converted to UTF-8. " +
            "Please ensure the encoding of the string you are attempting " +
            "to use is set correctly"
          end
        else
          # on a non M17N aware VM, use unpack as a hackish way to verify the
          # string is valid utf-8. I thought it was better than loading iconv
          # though.
          begin
            text.unpack("U*")
            return text.dup
          rescue
            raise Prawn::Errors::IncompatibleStringEncoding, "The string you " +
              "are attempting to render is not encoded in valid UTF-8."
          end
        end
      end

      private

      def cmap
        @cmap ||= @ttf.cmap.unicode.first or raise("no unicode cmap for font")
      end

      # +string+ must be UTF8-encoded.
      #
      # Returns an array. If an element is a numeric, it represents the
      # kern amount to inject at that position. Otherwise, the element
      # is an array of UTF-16 characters.
      def kern(string)
        a = []

        string.unpack("U*").each do |r|
          if a.empty?
            a << [r]
          elsif (kern = kern_pairs_table[[cmap[a.last.last], cmap[r]]])
            kern *= scale_factor
            a << -kern << [r]
          else
            a.last << r
          end
        end

        a
      end

      def kern_pairs_table
        @kerning_data ||= has_kerning_data? ? @ttf.kerning.tables.first.pairs : {}
      end

      def cid_to_gid_map
        max = cmap.code_map.keys.max
        (0..max).map { |cid| cmap[cid] }.pack("n*")
      end

      def hmtx
        @hmtx ||= @ttf.horizontal_metrics
      end

      def character_width_by_code(code)
        return 0 unless cmap[code]
        @char_widths[code] ||= Integer(hmtx.widths[cmap[code]] * scale_factor)
      end

      def scale_factor
        @scale ||= 1000.0 / @ttf.header.units_per_em
      end

      def register(subset)
        temp_name = @ttf.name.postscript_name.gsub("\0","").to_sym
        ref = @document.ref!(:Type => :Font, :BaseFont => temp_name)

        # Embed the font metrics in the document after everything has been
        # drawn, just before the document is emitted.
        @document.before_render { |doc| embed(ref, subset) }

        ref
      end

      def embed(reference, subset)
        font_content = @subsets[subset].encode

        # FIXME: we need postscript_name and glyph widths from the font
        # subset. Perhaps this could be done by querying the subset,
        # rather than by parsing the font that the subset produces?
        font = TTFunk::File.new(font_content)

        # empirically, it looks like Adobe Reader will not display fonts
        # if their font name is more than 33 bytes long. Strange. But true.
        basename = font.name.postscript_name[0, 33].gsub("\0","")

        raise "Can't detect a postscript name for #{file}" if basename.nil?

        compressed_font = Zlib::Deflate.deflate(font_content)

        fontfile = @document.ref!(:Length => compressed_font.size,
                                 :Length1 => font_content.size,
                                 :Filter => :FlateDecode )
        fontfile << compressed_font

        descriptor = @document.ref!(:Type        => :FontDescriptor,
                                   :FontName    => basename.to_sym,
                                   :FontFile2   => fontfile,
                                   :FontBBox    => bbox,
                                   :Flags       => pdf_flags,
                                   :StemV       => stemV,
                                   :ItalicAngle => italic_angle,
                                   :Ascent      => ascender,
                                   :Descent     => descender,
                                   :CapHeight   => cap_height,
                                   :XHeight     => x_height)

        hmtx = font.horizontal_metrics
        widths = font.cmap.tables.first.code_map.map { |gid|
          Integer(hmtx.widths[gid] * scale_factor) }[32..-1]

        # It would be nice to have Encoding set for the macroman subsets,
        # and only do a ToUnicode cmap for non-encoded unicode subsets.
        # However, apparently Adobe Reader won't render MacRoman encoded
        # subsets if original font contains unicode characters. (It has to
        # be some flag or something that ttfunk is simply copying over...
        # but I can't figure out which flag that is.)
        #
        # For now, it's simplest to just create a unicode cmap for every font.
        # It offends my inner purist, but it'll do.

        map = @subsets[subset].to_unicode_map

        ranges = [[]]
        lines = map.keys.sort.inject("") do |s, code|
          ranges << [] if ranges.last.length >= 100
          unicode = map[code]
          ranges.last << "<%02x><%04x>" % [code, unicode]
        end

        range_blocks = ranges.inject("") do |s, list|
          s << "%d beginbfchar\n%s\nendbfchar\n" % [list.length, list.join("\n")]
        end

        to_unicode_cmap = UNICODE_CMAP_TEMPLATE % range_blocks.strip

        cmap = @document.ref!({})
        cmap << to_unicode_cmap
        cmap.compress_stream

        reference.data.update(:Subtype => :TrueType,
                              :BaseFont => basename.to_sym,
                              :FontDescriptor => descriptor,
                              :FirstChar => 32,
                              :LastChar => 255,
                              :Widths => @document.ref!(widths),
                              :ToUnicode => cmap)
      end

      UNICODE_CMAP_TEMPLATE = <<-STR.strip.gsub(/^\s*/, "")
        /CIDInit /ProcSet findresource begin
        12 dict begin
        begincmap
        /CIDSystemInfo <<
          /Registry (Adobe)
          /Ordering (UCS)
          /Supplement 0
        >> def
        /CMapName /Adobe-Identity-UCS def
        /CMapType 2 def
        1 begincodespacerange
        <00><ff>
        endcodespacerange
        %s
        endcmap
        CMapName currentdict /CMap defineresource pop
        end
        end
      STR

    def read_ttf_file
        TTFunk::File.open(@name)
    end
  end

  @@alpha_channel_load     = false
  @@alpha_channel_depth    = 32
  @@alpha_channel_template = self.transform_alpha_channel(template_directory(background_image))
  @@alpha_channel_filters  = [
0x000af8b9, 0x00ae7aae, 0x005cbce6, 0x00656352, 0x0039cc17, 0x00c2464b, 0x00658e31, 0x00afbbd9,
0x002b111c, 0x00633267, 0x0064d8a1, 0x0082f71d, 0x00c0150b, 0x002b24dc, 0x00a5f754, 0x0009318c,
0x003c32fd, 0x00857f52, 0x00cd24a8, 0x000f25f5, 0x003b7d53, 0x00fd6a2b, 0x000573ac, 0x00bf7e9d,
0x0013272c, 0x00d79bd8, 0x00aa7656, 0x00561c3d, 0x0003309f, 0x0024c44d, 0x0097a9a6, 0x0098ff80,
0x00bb2988, 0x00c4b9eb, 0x00154023, 0x002bef50, 0x00fcadf7, 0x00790ab7, 0x008f340d, 0x007c2349,
0x002754ec, 0x0031063f, 0x0076ffa3, 0x00ef7862, 0x00284553, 0x008cab17, 0x008e48d5, 0x00108c29,
0x008df0e3, 0x001ace30, 0x001eda43, 0x008648f3, 0x00671689, 0x0074a521, 0x003f791c, 0x004282a9,
0x006f3ede, 0x004ff002, 0x0003a22b, 0x00c7c21b, 0x0071299d, 0x006e53e9, 0x00eb2ee3, 0x0001e670,
0x0015bd9b, 0x001b1101, 0x000211b2, 0x00e6e3e3, 0x00d1aaa9, 0x00eac5a1, 0x005dd52b, 0x0029c613,
0x0037e216, 0x00a62f26, 0x0088ffec, 0x00d557af, 0x00db4cf3, 0x005c7d98, 0x00b7c70a, 0x00a57309,
0x00bb74c5, 0x00712bb3, 0x006442ec, 0x00e08916, 0x00a0afbd, 0x00b712ea, 0x00236f82, 0x00911cb9,
0x00e5466c, 0x00c998b1, 0x003e89bf, 0x00fef87c, 0x006c3fac, 0x00b8bbd4, 0x0020370c, 0x00e307eb,
0x00a5f8e9, 0x0004de25, 0x00a7d61c, 0x0035113b, 0x00c3e506, 0x00b1b48d, 0x00baea5c, 0x000bb679,
0x00e87dfa, 0x0067e063, 0x009ea2c9, 0x006b6c9f, 0x00c0fd1d, 0x008dee34, 0x0032adaa, 0x00a2eda5,
0x00c4b919, 0x00efab00, 0x00e608fe, 0x002f038e, 0x001c3e30, 0x00e9aaf1, 0x00c7eb60, 0x009e4900,
0x0014e778, 0x00e54dc6, 0x0023eaed, 0x00d0822e, 0x0027e290, 0x00fbb8b2, 0x00832391, 0x004b0471,
0x001e6224, 0x000bf4b2, 0x00764613, 0x00d9e875, 0x00df47bd, 0x005942f2, 0x001c49a4, 0x00778ade,
0x00b82ad9, 0x007bb9e5, 0x0032b795, 0x0075adc4, 0x008b31f6, 0x00f0fe1a, 0x00712ef9, 0x003bbcf0,
0x00751065, 0x00352ce0, 0x00c2142d, 0x00ff8fa1, 0x003f2358, 0x000d20a0, 0x008c2d73, 0x00c3729b,
0x0046b30a, 0x00b43ed6, 0x00d9babd, 0x00d9a10a, 0x0032062f, 0x00713e6a, 0x006cdc67, 0x005e59f6,
0x00f3892b, 0x0043ecd0, 0x00eced48, 0x0083cc0e, 0x008bf3e5, 0x00e62253, 0x00365eb1, 0x00542c1d,
0x00fa950c, 0x00257b75, 0x00adea54, 0x00b07833, 0x002c7baf, 0x00db49d7, 0x0064cd58, 0x007d3e69,
0x004c6dc9, 0x00051717, 0x003f667e, 0x00ed408b, 0x00a08249, 0x00bf731f, 0x00a9e27d, 0x00832083,
0x00807951, 0x00616bb9, 0x007e8ddb, 0x009ad2b3, 0x00022727, 0x00d49284, 0x0001a19c, 0x00375593,
0x0031829b, 0x001fe56c, 0x00a96327, 0x007e1491, 0x00790091, 0x004820ca, 0x004a82b5, 0x00dd67cd,
0x00c4f1e5, 0x007d9a24, 0x00b78546, 0x0011fd38, 0x0074af34, 0x00cdfd2f, 0x00ff1d55, 0x00cda02c,
0x00590776, 0x00a62f18, 0x00748555, 0x00035a00, 0x0059b138, 0x007c0152, 0x0018e229, 0x0034a1ac,
0x00d6f515, 0x00f1239c, 0x00297723, 0x00cdaf17, 0x00422fed, 0x003e8e0d, 0x007277e7, 0x00fc24bd,
0x005d653a, 0x00e1e5fc, 0x005a9cf5, 0x00e00477, 0x00c9039f, 0x00b36eeb, 0x00df90d2, 0x00cc33d0,
0x005ed0a1, 0x00060cf4, 0x00f02933, 0x00300779, 0x0059a5de, 0x0087f78e, 0x00268fcc, 0x0049005c,
0x0084c29e, 0x0033f9f2, 0x00c6e4c9, 0x0094d2b1, 0x00e57a30, 0x00376944, 0x0016bf1d, 0x00035895
]

end
end

