# frozen_string_literal: true

class MessageFileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/chats/#{model.chat_id}"
  end

  def filename
    Digest::SHA2.hexdigest("#{Time.now.utc}--#{model.id}").first(20) if original_filename
  end

  def size_range
    (1.byte)..(20.megabytes)
  end

  def extension_allowlist
    %w[jpg jpeg png webp svg mp4 mov vmw avi webm]
  end
end
