# frozen_string_literal: true

require 'jquery-rails'
require 'will_paginate'

module BlogEngine
  class Engine < ::Rails::Engine
    isolate_namespace BlogEngine
  end
end
