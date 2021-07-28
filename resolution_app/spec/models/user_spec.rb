require 'rails_helper'

RSpec.describe User, type: :model do

    let!(:user) { create(:user) }

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:session_token) }
    it { should validate_uniqueness_of(:session_token) }
    it { should validate_uniqueness_of(:username) }

    describe 'password encryption' do
        it 'does not save password to the database' do
            FactoryBot.create(:user, username: 'Alex')

            user = User.find_by(username: 'Alex')
            expect(user.password).to_not eq('password')
        end

        it 'encrypts the password using BCrypt' do
            expect(BCrypt::Password).to receive(:create).with('password123')

            FactoryBot.build(:user, password: 'password123')
        end

        it 'properly sets the password reader' do
            expect(user.password).to eq('password')
        end
    end

    describe 'session token' do
        it 'assigns a session_token if one is not given' do
            expect(user.session_token).not_to be_nil
        end

        it 'resets a session token on a user' do
            old_token = user.session_token
            new_token = user.reset_session_token!
            expect(old_token).not_to eq(new_token)
        end
    end

    describe 'find user by credentials' do
        context 'with valid username and password' do
            it 'should return the proper user' do
                alex = User.create(username: 'Alex', password: 'password')
                test = User.find_by_credentials('Alex', 'password')

                expect(alex.username).to eq(test.username)
                expect(alex.password_digest).to eq(test.password_digest)
            end
        end

        context 'with invalid username and password' do
            it 'should return nil' do
                alex = User.create(username: 'Alex', password: 'password')
                test = User.find_by_credentials('Alex', 'blah')
                expect(test).to be_nil
            end
        end
    end




    


end
