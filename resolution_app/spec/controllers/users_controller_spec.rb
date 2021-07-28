require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    let!(:user) { create(:user) }

    describe 'GET #new' do
        it 'renders the new users template' do
            get :new
            expect(response).to render_template('new')
        end
    end

    describe 'POST #create' do
        before :each do
            create(:user)
            allow(subject).to receive(:current_user).and_return(User.last)
        end

        let(:valid_params){ { user: {username: 'Alex'}} }
        let(:invalid_params){ { user: {blah: ''}} }

        context 'with valid params' do
            it 'creates the user' do
                post :create, params: valid_params
                expect(User.last.username).to eq('Alex')
            end
        end
            
    end
end