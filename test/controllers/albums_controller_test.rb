require "test_helper"

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @album = albums(:one)
    @admin = users(:admin)
    @user = users(:regular)
  end

  test "should get index" do
    get albums_url
    assert_response :success
  end

  test "should show album" do
    get album_url(@album)
    assert_response :success
    assert_select "p.dossier-lead", text: /Разбор этого альбома будет позже/
    assert_select "h1", text: "folklore", count: 0
  end

  test "folklore shows the full dossier" do
    folklore = Album.create!(title: "folklore", artist: "Taylor Swift", year: 2020, genre: "инди-фолк")
    get album_url(folklore)
    assert_response :success
    assert_select "h1.dossier-title", text: "folklore"
    assert_select "a[href='#themes']"
  end

  test "get up shows the same dossier sections" do
    get_up = Album.create!(title: "Get Up", artist: "NewJeans", year: 2023, genre: "K-Pop")
    get album_url(get_up)
    assert_response :success
    assert_select "h1.dossier-title", text: "Get Up"
    assert_select "a[href='#about']"
    assert_select "a[href='#themes']"
    assert_select "a[href='#materials']"
    assert_select "a[href='#explore']"
    assert_select "a[href='#sources']"
    assert_select "a[href='#discussion']"
  end

  test "guest can search albums" do
    get search_albums_url, params: { q: @album.title }
    assert_response :success
    assert_select "turbo-frame#search_results a", /#{Regexp.escape(@album.title)}/
  end

  test "blank search returns no albums" do
    get search_albums_url, params: { q: "   " }
    assert_response :success
    assert_select "turbo-frame#search_results a", count: 0
  end

  test "album page shows seeded comments and a form for members" do
    sign_in @user
    @album.comments.create!(body: "Камерный разбор", user: @user)
    get album_url(@album)
    assert_response :success
    assert_select "#discussion", text: /Камерный разбор/
    assert_select "#discussion form textarea"
  end

  test "guest sees comments but not the form" do
    @album.comments.create!(body: "Только чтение", user: @user)
    get album_url(@album)
    assert_response :success
    assert_select "#discussion", text: /Только чтение/
    assert_select "#discussion form", count: 0
  end

  test "guest cannot get new" do
    get new_album_url
    assert_redirected_to new_user_session_url
  end

  test "regular user cannot get new" do
    sign_in @user
    get new_album_url
    assert_redirected_to root_path
  end

  test "admin should get new" do
    sign_in @admin
    get new_album_url
    assert_response :success
  end

  test "admin should create album" do
    sign_in @admin
    assert_difference("Album.count") do
      post albums_url, params: { album: { artist: "Artist", title: "Title", genre: "Pop", year: 2024 } }
    end

    assert_redirected_to album_url(Album.last)
  end

  test "regular user cannot create album" do
    sign_in @user
    assert_no_difference("Album.count") do
      post albums_url, params: { album: { artist: "Artist", title: "Title" } }
    end
    assert_redirected_to root_path
  end

  test "admin should get edit" do
    sign_in @admin
    get edit_album_url(@album)
    assert_response :success
  end

  test "admin should update album" do
    sign_in @admin
    patch album_url(@album), params: { album: { artist: "Updated", title: @album.title } }
    assert_redirected_to album_url(@album)
  end

  test "admin should destroy album" do
    sign_in @admin
    assert_difference("Album.count", -1) do
      delete album_url(@album)
    end

    assert_redirected_to albums_url
  end
end
