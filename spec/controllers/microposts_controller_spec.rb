require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe '#create' do
    let(:micropost) { FactoryGirl.build(:micropost, user: user) }

    it { expect{ post :create, params: { micropost: micropost } }.to change{ user.microposts.count }.by(0) }

    it "should redirect create when not logged in" do
      post :create, params: { micropost: micropost }
      expect(response).to redirect_to("/login")
    end
  end

  describe '#destroy' do
    let!(:micropost) { FactoryGirl.create(:micropost, user: user) }

    context 'user not logged in' do
      it { expect{ delete :destroy, params: { id: micropost.id } }.to change{ user.microposts.count }.by(0) }

      it "should redirect destroy" do
        delete :destroy, params: { id: micropost.id }
        expect(response).to redirect_to("/login")
      end
    end

    context 'logged in as wrong user' do
      let(:other_user) { FactoryGirl.create(:user, email: 'mina@example.com') }

      before do
        allow(controller).to receive(:current_user) { other_user }
      end

      it { expect{ delete :destroy, params: { id: micropost.id } }.to change{ user.microposts.count }.by(0) }

      it "should redirect destroy" do
        delete :destroy, params: { id: micropost.id }
        expect(response).to redirect_to("/")
      end
    end

    context 'logged in as correct user' do
      before do
        allow(controller).to receive(:current_user) { user }
      end
      it { expect{ delete :destroy, params: { id: micropost.id } }.to change{ user.microposts.count }.by(-1) }
    end
  end
end
