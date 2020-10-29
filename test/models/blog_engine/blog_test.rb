# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/../../test_helper"

module BlogEngine
  class BlogTest < ActiveSupport::TestCase
    fixtures :blogs

    # Replace this with your real tests.
    def test_truth
      assert true
    end
  end
end
