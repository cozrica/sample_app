require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:michael) { FactoryGirl.create(:michael) }
  let(:mina) { FactoryGirl.create(:mina) }

  describe '#valid?' do
    let(:relationship) { FactoryGirl.build(:relationship, params) }
    context "should be valid" do
      let(:params) { { follower: michael, followed: mina } }
      it { expect(relationship).to be_valid }
    end

    context "should require a follower_id" do
      let(:params) { { follower: nil, followed: mina } }
      it { expect(relationship).not_to be_valid }
    end

    context "should require a followed_id" do
      let(:params) { { follower: michael, followed: nil } }
      it { expect(relationship).not_to be_valid }
    end
  end
end
