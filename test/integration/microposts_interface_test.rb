require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # 無効なマイクロポスト投稿
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な投稿
    content = "Valid post"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_path
    follow_redirect!
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(micropost)
    end
    assert_not flash.empty?
    # 他のユーザページにアクセス
    get user_path(users(:mina))
    assert_select 'a', text: 'delete', count: 0
  end

  test "sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    other_user = users(:mina)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    post microposts_path, params: { micropost: { content: "Hi" } }
    follow_redirect!
    assert_match "1 micropost", response.body
  end
end
