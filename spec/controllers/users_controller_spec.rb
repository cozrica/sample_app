require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:user, email: "nami@example.com", admin: false) }

  describe "#new" do
    it "has a ok status" do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe "#index" do
    context "when not logged in" do
      it "should redirect" do
        get :index
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "#edit" do
    context "when not logged in" do
      it "should redirect" do
        get :edit, params: { id: user.id }
        expect(flash[:danger]).not_to be_empty
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in as wrong user" do
      before do
        allow(controller).to receive(:current_user) { other_user }
      end

      it "should redirect" do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "#update" do
    context "when not logged in" do
      it "should redirect" do
        patch :update, params: { id: user.id, user: { name: "Foo",
                                                      email: "foo@valid.com",
                                                      password: "",
                                                      password_confirmation: "" } }
        expect(flash[:danger]).not_to be_empty
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in as wrong user" do
      before do
        allow(controller).to receive(:current_user) { other_user }
      end

      it "should redirect update" do
        patch :update, params: { id: user.id, user: { name: "Foo",
                                                      email: "foo@valid.com",
                                                      password: "",
                                                      password_confirmation: "" } }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "#destroy" do
    context "when not logged in" do
      it { expect{ delete :destroy, params: { id: user.id } }.to change{ User.count }.by(0) }
      it "should redirect" do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in as non admin user" do
      before do
        allow(controller).to receive(:current_user) { other_user }
      end
      it "should not destroy" do
        expect{ delete :destroy, params: { id: user.id } }.to change{ User.count }.by(0)
      end
    end
  end

  describe "#following" do
    context "when not logged in" do
      it "should redirect" do
        get :following, params: { id: user.id }
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "admin attribute" do
    let!(:other_user) { FactoryGirl.create(:user, email: "nami@example.com", admin: false) }
    before do
      allow(controller).to receive(:current_user) { other_user }
    end

    it "should not allow to be edited via the web" do
      expect(other_user).not_to be_admin
      patch :update, params: { id: other_user.id, user: { name: "Foo",
                                                      email: "foo@valid.com",
                                                      password: "",
                                                      password_confirmation: "",
                                                      admin: true } }
      expect(other_user).not_to be_admin
    end
  end
end
