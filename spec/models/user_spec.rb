require 'spec_helper'

describe User do
  let(:attributes) do
    {
      name: 'The Stig',
      email: 'stig@topgear.co.uk',
      password: 'foobar',
      password_confirmation: 'foobar'
    }
  end

  it { should have(1).error_on(:name) }
  it { should have(1).error_on(:email) }

  it 'rejects names that are too long' do
    User.new(attributes.merge(name: 'a' * 31)).should_not be_valid
  end

  it 'should accept valid email adresses' do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jpg]
    addresses.each do |address|
      user = User.new(attributes.merge(email: address))
      user.should be_valid
    end
  end

  it 'should reject invalid email adresses' do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      user = User.new(attributes.merge(:email => address))
      user.should_not be_valid
    end
  end

  it 'should reject duplicate email addresses' do
    User.create!(attributes)

    user = User.new(attributes)
    user.should have(1).error_on(:email)
  end

  it 'should reject email addresses identical up to case' do
    User.create!(attributes.merge(email: attributes[:email].upcase))

    user = User.new(attributes)
    user.should have(1).error_on(:email)
  end

  it 'should not be an admin by default' do
    User.new.should_not be_admin
  end

  describe 'password validations' do
    it 'should require a password' do
      User.new(attributes.merge(password: '', password_confirmation: '')).should_not be_valid
    end

    it 'should require a matching password confirmation' do
      User.new(attributes.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it 'should reject short passwords' do
      User.new(attributes.merge(password: 'a' * 5, password_confirmation: 'a' * 5)).should_not be_valid
    end

    it 'should reject long passwords' do
      User.new(attributes.merge(password: 'a' * 41, password_confirmation: 'a' * 41)).should_not be_valid
    end
  end
end
