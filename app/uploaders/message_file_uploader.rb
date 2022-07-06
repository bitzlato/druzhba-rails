# frozen_string_literal: true

class MessageFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::BombShelter
  storage :file

  def store_dir
    "uploads/chats/#{model.chat_id}"
  end

  def filename
    model[:file] || Digest::SHA2.hexdigest("#{Time.now.utc}--#{model.id}").first(20) if original_filename
  end

  def size_range
    (1.byte)..(20.megabytes)
  end

  def extension_allowlist
    %w[jpg jpeg png webp svg mp4 mov vmw avi webm]
  end

  def optimize
    manipulate! do |img|
      return img unless img.mime_type.match %r{image/jpeg}

      img.strip
      img.combine_options do |c|
        c.quality '80'
        c.depth '8'
        c.interlace 'plane'
      end
      img
    end
  end

  process :optimize
end
