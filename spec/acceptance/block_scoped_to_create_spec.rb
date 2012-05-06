require 'spec_helper'

describe 'block-scoped to_create' do
  before do
    define_model('User', name: :string)
    define_model('Company', name: :string)

    FactoryGirl.define do
      factory :user do
        name 'John Doe'

        factory :awesome_user do
          to_create {|instance| instance.save! }
        end
      end

      factory :company do
        name 'thoughtbot, inc.'
      end

      to_create {|instance| instance.name = 'overridden' }
    end

    FactoryGirl.define do
      factory :different_user, class: User do
        name 'Jane Doe'
      end

      factory :different_company, class: Company do
        name 'bocoup'
      end
    end
  end

  context 'creating records from factories defined with a global to_create' do
    it 'uses the global to_create for all factories' do
      FactoryGirl.create(:user).name.should == 'overridden'
      FactoryGirl.create(:company).name.should == 'overridden'
    end

    it 'allows overriding to_create per factory' do
      FactoryGirl.create(:awesome_user).name.should == 'John Doe'
    end
  end

  context 'creating records from factories defined in a block without to_create' do
    it "doesn't use a previously defined to_create" do
      FactoryGirl.create(:different_user).name.should == 'Jane Doe'
      FactoryGirl.create(:different_company).name.should == 'bocoup'
    end
  end

  context 'defining child factories in a different FactoryGirl.define' do
    before do
      FactoryGirl.define do
        factory :child, parent: :user do
          name 'Child Doe'
        end
      end
    end

    it 'does not use the to_create from the other define block' do
      FactoryGirl.create(:child).name.should == 'Child Doe'
    end
  end
end
