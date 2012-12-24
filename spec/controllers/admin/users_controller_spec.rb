require 'spec_helper'

describe Admin::UsersController do
  before(:each) do
    admin = create_user
    admin.toggle!(:admin)
    controller_sign_in(admin)
  end

  describe 'destroy' do
    before(:each) do
      @user = create_user('john@example.com')
    end

    it 'deletes a user' do
      lambda do
        delete :destroy, id: @user.id
      end.should change(User, :count).by(-1)
    end
  end
end
