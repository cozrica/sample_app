require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#valid?' do
    let(:user) { FactoryGirl.build(:user, params) }

    context "should be valid" do
      let(:params) { { } }
      it { expect(user).to be_valid }
    end

    context "name should be present" do
      let(:params) { { name: "" } }
      it { expect(user).not_to be_valid }
    end

    context "email should be present" do
      let(:params) { { email: "" } }
      it { expect(user).not_to be_valid }
    end

    context "name should not be too long" do
      let(:params) { { name: "r" * 41 } }
      it { expect(user).not_to be_valid }
    end

    context "email should not be too long" do
      let(:params) { { email: "r" * 41 } }
      it { expect(user).not_to be_valid }
    end

    context "email validation should accept valid addresses" do
      it {
        %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn].each do |valid_address|
          user = FactoryGirl.build(:user, email: valid_address)
          expect(user).to be_valid
        end
      }
    end

    context "email validation should reject invalid addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        let(:params) { { email: invalid_address } }
        it { expect(user).not_to be_valid }
      end
    end

    context "email should be unique" do
      let(:email) { "same@example.com" }
      let(:params) { { email: email.upcase } }

      before do
        FactoryGirl.create(:user, email: email)
      end

      it { expect(user).not_to be_valid }
    end

    context "email should be saved as lower-case" do
      let(:mixed_case_email) { "Rika@gMail.Com" }
      let(:user) { FactoryGirl.create(:user, email: mixed_case_email) }
      it { expect(user.email).to eq mixed_case_email.downcase }
    end

    context "password should be present (nonblank)" do
      let(:params) { { password_digest: "" } }
      it { expect(user).not_to be_valid }
    end

    context "associated microposts should be destroyed" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:micropost) { FactoryGirl.create(:micropost, user: user) }

      it { expect{ user.destroy }.to change{ user.microposts.count }.by(-1) }
    end

    context "should follow a user" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:other_user) { FactoryGirl.create(:user, email: "test@example.com") }

      before do
        user.follow(other_user)
      end

      it { expect(user).to be_following(other_user) }
      it { expect(other_user.followers).to include(user)}
    end

    context "should unfollow a user" do
      let!(:michael) { FactoryGirl.create(:michael) }
      let!(:mina) { FactoryGirl.create(:mina) }
      before do
        FactoryGirl.create(:relationship, { follower: michael, followed: mina })
        michael.unfollow(mina)
      end

      it { expect(michael).not_to be_following(mina) }
    end
  end
end
