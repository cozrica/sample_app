require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "get new" do
    it "has a ok status" do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end
end

