require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  render_views
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe 'get home' do
    it 'title matches base' do
      get :home
      expect(response).to have_http_status(:ok)
      expect(response.body).to match "<title>#{base_title}"
    end
  end

  describe 'get help' do
    it 'title matches help' do
      get :help
      expect(response).to have_http_status(:ok)
      expect(response.body).to match "<title>Help | #{base_title}"
    end
  end
end

