require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) { build_stubbed(:cart) }

  describe '#ActiveRecord associations' do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end

  describe '#quantity' do
    it { expect(cart).to validate_presence_of(:quantity) }
  end

  describe '#user_id' do
    it { expect(cart).to have_db_column(:user_id).of_type(:integer) }
  end

  describe '#product_id' do
    it { expect(cart).to have_db_column(:product_id).of_type(:integer) }
  end

  describe '#quantity' do
    it { expect(cart).to have_db_column(:quantity).of_type(:integer) }
  end

  describe '#status' do
    it { expect(cart).to have_db_column(:status).of_type(:string)
                                                .with_options(default: 'active') }
  end
end
