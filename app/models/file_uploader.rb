class FileUploader < CarrierWave::Uploader::Base
  storage :file

  include CarrierWave::MiniMagick

  process :resize_and_orient => [800, 800]

  version :thumb do
    process :resize_and_orient => [200, 200]
  end
        
  def extension_white_list
    %w(jpg jpeg)
  end
  
  def resize_and_orient(width, height)
    manipulate! do |img|
      img.resize "#{width}x#{height}"
      img.auto_orient
      img
    end
  end
end