# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/../../test_helper"

module BlogEngine
  class BlogEntryTest < ActiveSupport::TestCase
    fixtures :blog_entries

    # Replace this with your real tests.
    def test_truth
      assert true
    end
  end
end
