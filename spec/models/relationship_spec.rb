require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:michael) { FactoryGirl.create(:user) }
  let(:mina) { FactoryGirl.create(:user, email: "mina@example.com") }

  describe '#valid?' do
    let(:relationship) { FactoryGirl.build(:relationship, params) }

    context "should be valid" do
      let(:params) { { follower: michael, followed: mina } }
      it { expect(relationship).to be_valid }
    end

    context "follower_id not present" do
      let(:params) { { follower: nil, followed: mina } }
      it { expect(relationship).to be_invalid }
    end

    context "followed_id not present" do
      let(:params) { { follower: michael, followed: nil } }
      it { expect(relationship).to be_invalid }
    end
  end
end
