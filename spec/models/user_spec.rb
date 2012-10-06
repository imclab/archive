require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name                  => "The Stig",
      :email                 => "stig@topgear.co.uk",
      :password              => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should require a name" do
    User.new(@attr.merge(:name => "")).should_not be_valid
  end

  it "should require an email adress" do
    User.new(@attr.merge(:email => "")).should_not be_valid
  end

  it "should reject names that are too long" do
    User.new(@attr.merge(name: 'a' * 31)).should_not be_valid
  end

  it "should accept valid email adresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jpg]
    addresses.each do |address|
      user = User.new(@attr.merge(email: address))
      user.should be_valid
    end
  end

  it "should reject invalid email adresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      user = User.new(@attr.merge(:email => address))
      user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)

    user = User.new(@attr)
    user.should have(1).error_on(:email)
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(email: upcased_email))

    user = User.new(@attr)
    user.should have(1).error_on(:email)
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(password: '', password_confirmation: '')).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      User.new(@attr.merge(password: 'a' * 5, password_confirmation: 'a' * 5)).should_not be_valid
    end

    it "should reject long passwords" do
      User.new(@attr.merge(password: 'a' * 41, password_confirmation: 'a' * 41)).should_not be_valid
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end
  end

  describe "association with comments" do
    it "should show the right comments" do
      user        = User.create!(@attr)
      comment_one = Comment.create!(user_id: user.id, text: "Stig was here!")
      comment_two = Comment.create!(user_id: user.id, text: "Here too")

      user.comments.should == [comment_one, comment_two]
    end
  end
end
