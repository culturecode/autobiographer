class FileUploader < CarrierWave::Uploader::Base
  if Rails.env == :production
    storage :s3
  else
    storage :file
  end

  include CarrierWave::MiniMagick

  process :resize_and_orient => [800, 800]

  version :thumb do
    process :resize_and_orient => [200, 200]
  end
        
  def extension_white_list
    %w(jpg jpeg)
  end
  
  def store_dir
    "#{model.class.to_s.tableize}/#{model.id}"
  end
  
  def resize_and_orient(width, height)
    manipulate! do |img|
      img.resize "#{width}x#{height}"
      img.auto_orient
      img
    end
  end
end