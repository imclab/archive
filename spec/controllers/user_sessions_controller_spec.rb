require 'spec_helper'

describe UserSessionsController do
  describe 'create' do
    context "invalid login data" do
      it 'should re-render the new page' do
        post :create, user_session: { email: 'email@example.com', password: 'invalid' }

        response.should render_template('new')
      end
    end

    context 'valid login data' do
      let(:user) {
        create_user
      }

      it 'should sign the user in' do
        post :create, user_session: { email: user.email, password: user.password }

        controller.current_user.should == user
      end

      it 'redirects to the sessions page' do
        post :create, user_session: { email: user.email, password: user.password }

        response.should redirect_to(sessions_path)
      end


      it 'redirects to return_to path' do
        session[:return_to] = '/bananensaft'

        post :create, user_session: { email: user.email, password: user.password }

        response.should redirect_to('/bananensaft')
      end

      it 'clears return_to path after redirect' do
        session[:return_to] = '/bananensaft'

        post :create, user_session: { email: user.email, password: user.password }

        session[:return_to].should be_nil
      end
    end
  end

  describe 'destroy' do
    it 'should sign user out' do
      controller_sign_in(create_user)

      delete :destroy

      controller.current_user.should == nil
    end
  end
end
