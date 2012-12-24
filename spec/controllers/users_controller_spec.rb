require 'spec_helper'

describe UsersController do
  describe 'create' do
    context 'invalid attributes' do
      it 'does not create a user and rerender the form' do
        lambda do
          post :create, user: { name: '', email: '', password: '', password_confirmation: '' }
        end.should_not change(User, :count)

        response.should render_template('new')
      end
    end

    context 'valid attributes' do
      it 'creates a user and redirect to sessions index' do
        lambda do
          post :create, :user => { name: 'bob', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar' }
        end.should change(User, :count).by(1)

        response.should redirect_to(sessions_path)
      end
    end
  end

  describe 'edit' do
    let(:user) {
      create_user
    }

    context 'as signed-in but wrong user' do
      let(:wrong_user) {
        create_user('wrong@gmail.com')
      }

      it 'redirects to root path' do
        controller_sign_in(wrong_user)

        get :edit, id: user.id

        response.should redirect_to(root_path)
      end
    end

    context 'as signed-in user' do
      it 'is successful' do
        controller_sign_in(user)

        get :edit, id: user.id

        response.should be_success
      end
    end

    context 'as signed-out user' do
      it 'redirects to sign-in path' do
        get :edit, id: user.id

        response.should redirect_to(signin_path)
      end
    end
  end

  describe 'update' do
    let(:user) {
      create_user
    }

    context 'as signed-out user' do
      it 'redirects to signin-path' do
        put :update, id: user.id, user: { name: 'Bobby' }

        response.should redirect_to(signin_path)
      end
    end

    context 'as signed-in but wrong user' do
      let(:wrong_user) {
        create_user('wrong@gmail.com')
      }

      it 'redirects to root path' do
        controller_sign_in(wrong_user)

        put :update, id: user.id, user: { name: 'Bobby' }

        response.should redirect_to(root_path)
      end
    end

    context 'as signed-in user' do
      before(:each) do
        controller_sign_in(user)
      end

      context 'with invalid form attributes' do
        it 'rerenders the edit template' do
          put :update, id: user.id, user: { email: '', name: '', password: '', password_confirmation: '' }

          response.should render_template('edit')
        end
      end

      describe 'success' do
        let(:attr) do
          { email: 'johnny22@feobar.com', name: 'Johnny Second', password: 'password', password_confirmation: 'password' }
        end

        it 'updates the users attributes' do
          put :update, id: user.id, user: attr

          user.reload

          user.name.should == attr[:name]
          user.email.should == attr[:email]
        end

        it 'redirects to the sessions_page' do
          put :update, id: user.id, user: attr

          response.should redirect_to(sessions_path)
        end
      end
    end
  end
end
