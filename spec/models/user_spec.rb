require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build_stubbed(:user) }

  describe '#email' do
    it { expect(user).to have_db_column(:email).of_type(:string) }
  end

  describe '#guest' do
    it { expect(user).to have_db_column(:guest).of_type(:boolean) }
  end
end
