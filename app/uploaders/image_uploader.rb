# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production? or Rails.env.staging?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if model.photoable.class == Candidate
      "candidates"
    else
      "photos/#{model.id}"
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  
  process :convert => 'jpg'

  # Create different versions of your uploaded files:
  version :small do
    process :resize_to_fill => [50, 50]
    process :convert => 'jpg'
    def full_filename(for_file)
     filename 50
    end
  end
  
  version :medium do
    process :resize_to_fill => [100, 100]
    process :convert => 'jpg'
    def full_filename(for_file)
      filename 100
    end
  end
  
  version :large do
    process :resize_to_fill => [300, 300]
    process :convert => 'jpg'
    def full_filename(for_file)
      filename 300
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename(size_px = 'original')
    if original_filename
      if model.photoable.class == Candidate
        candidate_photo_name(size_px)
      else
        "original.jpg"
      end
    end
  end


  protected
    def candidate_photo_name(size_px = 'original')
      "#{model.photoable.namespace}-#{size_px}.jpg"
    end
end
