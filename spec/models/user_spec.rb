require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    it "nameとemail、passwordとpassword_confirmationが存在すれば登録できること" do #正常系
      expect(@user).to be_valid
    end

    it "nameが空では登録できないこと" do #異常系
      @user.name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Name can't be blank")
    end

    it "emailが空では登録できないこと" do
      @user.email = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it "passwordが空では登録できないこと" do
      @user.password = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end
    it "passwordが存在してもpassword_confirmationが空では登録できないこと" do
      @user.password_confirmation = "" #nilにすると、前のpasswordとの値との不一致が生じる
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it "重複したemailが存在する場合登録できないこと" do
      @user.save #まず生成した@userをテーブルに保存する。
      another_user = FactoryBot.build(:user, email: @user.email) #FactoryBotを用いて、user情報の中でも「email」だけを選択してインスタンスを生成
      another_user.email = @user.email #変数another_userのemailを既に保存済みの@userのemailに上書き
      another_user.valid? #another_userが保存されるか検証
      expect(another_user.errors.full_messages).to include ("Email has already been taken")
    end
  end
end
