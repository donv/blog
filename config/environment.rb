# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# FIXME(uwe): Push upstream
class Magick::Image
  def thumbnail(scale)
    resize(scale)
  end
end

class Mail::Message
  def deliver_now
    deliver
  end
end
