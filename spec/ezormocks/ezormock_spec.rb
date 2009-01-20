require File.join(File.dirname(__FILE__), "/../spec_helper")

class ExampleModel
end

describe "ezormock" do
  describe "class methods" do
    it "stubs find on the class object, returning an ezomock instance" do
      ezormock(ExampleModel)
      ExampleModel.find("37").should be_an_instance_of(Spec::Mocks::Mock)
    end
    it "stubs new on the class object, returning an ezomock instance" do
      ezormock(ExampleModel)
      ExampleModel.new.should be_an_instance_of(Spec::Mocks::Mock)
    end
    it "stubs all on the class object, returning an ezomock instance in an array" do
      ezormock(ExampleModel)
      ExampleModel.all.should have(1).element
      ExampleModel.all.first.should be_an_instance_of(Spec::Mocks::Mock)
    end
  end
  
  context "creating" do
    it "yields the instance" do
      instance = nil
      ezormock(ExampleModel) do |yielded_instance|
        instance = yielded_instance
      end
      instance.should be_an_instance_of(Spec::Mocks::Mock)
    end
  end

  describe "instances" do
    context "default (savable)" do
      def savable
        @savable = ezormock(ExampleModel)
      end
      
      it "returns true for save" do
        savable.save.should be_true
      end

      it "returns true for save!" do
        savable.save!.should be_true
      end

      it "returns true for update_attribute" do
        savable.update_attribute.should be_true
      end

      it "returns true for update_attributes" do
        savable.update_attributes.should be_true
      end

      it "returns true for update_attributes!" do
        savable.update_attributes!.should be_true
      end
    end
    
    context "unsavable" do
      def unsavable
        @unsavable = ezormock(ExampleModel, :savable => false)
      end
      
      it "returns false for save" do
        unsavable.save.should be_false
      end

      it "raises on save!" do
        lambda {
          unsavable.save!
        }.should raise_error(ActiveRecord::RecordInvalid)
      end

      it "returns false for update_attribute" do
        unsavable.update_attribute.should be_false
      end

      it "returns false for update_attributes" do
        unsavable.update_attributes.should be_false
      end

      it "raises on update_attributes!" do
        lambda {
          unsavable.update_attributes!
        }.should raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end