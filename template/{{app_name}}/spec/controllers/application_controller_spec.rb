# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe "View paths" do
    it "first resolves to app/views/overrides" do
      first_view_path = controller.view_paths.first
      expect(first_view_path.path).to eq File.expand_path("app/views/overrides")
    end
  end
end
