require 'spec_helper'

describe Admin::BaseController do
  controller do
    def index
      render nothing: true
    end
  end

  context 'as logged-in user' do
    let(:user) {
      create_user
    }

    before(:each) do
      controller.sign_in(user)
    end

    context 'without admin rights' do
      it 'redirects me to the sessions path' do
        get :index

        response.should redirect_to(sessions_path)
      end
    end

    context 'with admin rights' do
      it 'responds successfully' do
        user.update_attribute(:admin, true)

        get :index

        response.should be_successful
      end
    end
  end
end
