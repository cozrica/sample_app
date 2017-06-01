require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:michael) { FactoryGirl.create(:user) }
  let(:mina) { FactoryGirl.create(:user, email: "mina@example.com") }
  let!(:relationship) { FactoryGirl.create(:relationship, follower: michael, followed: mina) }

  describe "#create" do
    context "when not logged in" do
      it { expect{ post :create, params: { id: relationship.id } }.to change{ Relationship.count }.by(0) }
      it "should redirect" do
        post :create, params: { id: relationship.id }
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "#destroy" do
    context "when not logged in" do
      it { expect{ delete :destroy, params: { id: relationship.id } }.to change{ Relationship.count }.by(0) }
      it "should redirect" do
        delete :destroy, params: { id: relationship.id }
        expect(response).to redirect_to(login_url)
      end
    end
  end
end
