require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryGirl.create(:michael) }

  describe '#valid?' do
    let(:micropost) { FactoryGirl.build(:micropost, params) }

    context "has user id" do
      let(:params) { {content: "Hi", user: user} }
      it { expect(micropost).to be_valid }
    end

    context "user id should be present" do
      let(:params) { { content: "Hi", user_id: nil } }
      it { expect(micropost).not_to be_valid }
    end

    context "content should be present" do
      let(:params) { { content: "", user: user } }
      it { expect(micropost).not_to be_valid }
    end

    context "content should be at most 140 characters" do
      let(:params) { { content: "a" * 141, user: user }}
      it { expect(micropost).not_to be_valid }
    end
  end

  describe '#first' do
    let(:most_recent) { FactoryGirl.create(:micropost, created_at: Time.zone.now, user: user) }

    before do
      FactoryGirl.create_list(:micropost, 3, user: user)
    end

    it { expect(most_recent).to eq Micropost.first }
  end
end
