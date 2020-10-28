# frozen_string_literal: true

require 'test_helper'

module BlogEngine
  class Test < ActiveSupport::TestCase
    test 'truth' do
      assert_kind_of Module, Blog
    end
  end
end
