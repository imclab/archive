require 'spec_helper'

describe SessionsController do
  describe 'index' do
    it 'orders the sessions based on the passed in sort parameter' do
      Session.should_receive(:by_session_date)

      get :index, sort: 'by_session_date'
    end

    it 'reverses the order when the reverse param is passed in' do
      sessions = stub(:sessions)
      Session.stub(by_session_date: sessions)

      sessions.should_receive(:reverse!)

      get :index, sort: 'by_session_date', reverse: true
    end
  end
end
