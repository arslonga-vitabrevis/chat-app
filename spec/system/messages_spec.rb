require 'rails_helper'

RSpec.describe "メッセージ投稿機能", type: :system do
  before do
    # 中間テーブルを作成して、中間テーブルに紐づいているusersテーブルとroomsテーブルのレコードを作成する
    @room_user = FactoryBot.create(:room_user)
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗すること' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # DBに保存されていないことを期待する
      # メッセージを送信するために、findメソッドを使用して、
      # 送信ボタンの「input[name="commit"]」要素を取得して、クリック
      expect{
        find('input[name="commit"]').click
      }.not_to change { Message.count }

      # 元のページに戻ってくることを期待する
      expect(current_path).to eq  room_messages_path(@room_user.room)
    end
  end

  context '投稿に成功したとき' do
    context '投稿に成功したとき' do
      it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
        # サインインする
        sign_in(@room_user.user)
  
        # 作成されたチャットルームへ遷移する
        click_on(@room_user.room.name)
  
        # 値をテキストフォームに入力する
        post = "テスト"
        fill_in 'message_content', with: post
  
        # 送信した値がDBに保存されていることを期待する
        expect{
          find('input[name="commit"]').click
        }.to change { Message.count }.by(1)
  
        # 投稿一覧画面に遷移することを期待する
        expect(current_path).to eq room_messages_path(@room_user.room)
  
        # 送信した値がブラウザに表示されていることを期待する
        expect(page).to have_content(post)
      end
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      # 添付する画像を定義して、「image_path」に代入。
      # attach_fileメソッドを使用して、画像をアップロード
      # make_visible: trueを付けることで非表示になっている要素も一時的に hidden でない状態になる
      image_path = Rails.root.join('public/images/test_image.jpg')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)

      # 送信した値がDBに保存されていることを期待する
      expect{
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)

      # 投稿一覧画面に遷移することを期待する
      expect(current_path).to eq room_messages_path(@room_user.room)

      # 送信した画像がブラウザに表示されていることを期待する
      expect(page).to have_selector("img")
    end

    it 'テキストと画像の投稿に成功すること' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.jpg')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)

      # 値をテキストフォームに入力する
      post = "テスト"
      fill_in 'message_content', with: post

      # 送信した値がDBに保存されていることを期待する
      expect{
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)

      # 送信した値がブラウザに表示されていることを期待する
      expect(page).to have_content(post)

      # 送信した画像がブラウザに表示されていることを期待する
      expect(page).to have_selector("img")

      # 今回のテストコードでは、投稿を行った後に一覧表示に戻るコードを省いている
      # 投稿したメッセージと画像をhave_selectorで取得することで
      # 一覧表示画面に遷移出来ていることが確認できるため
    end
  end
end
