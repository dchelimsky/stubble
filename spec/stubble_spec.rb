require File.join(File.dirname(__FILE__), "/spec_helper")

class ExampleModel
end

describe "stubble" do
  describe "class methods" do
    describe "find()" do
      it "returns a stubbled instance when given no args" do
        model = stubble(ExampleModel)
        ExampleModel.find("37").should == model
      end

      it "returns a stubbled instance when given :id => the same id passed to find" do
        model = stubble(ExampleModel, :id => "37")
        ExampleModel.find("37").should == model
      end

      it "raises RecordNotFound when given :id => the wrong id" do
        model = stubble(ExampleModel, :id => "37")
        lambda do
          ExampleModel.find("42")
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    it "stubs new on the class object, returning an stubbled instance" do
      model = stubble(ExampleModel)
      ExampleModel.new.should == model
    end
    it "stubs all on the class object, returning an stubbled instance in an array" do
      model = stubble(ExampleModel)
      ExampleModel.all.should == [model]
    end
  end
  
  context "creating" do
    it "yields the instance" do
      instance = nil
      stubble(ExampleModel) do |yielded_instance|
        instance = yielded_instance
      end
      instance.should be_an_instance_of(Spec::Mocks::Mock)
    end
  end

  describe "instances" do
    context "default (savable)" do
      def savable
        @savable = stubble(ExampleModel)
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
        @unsavable = stubble(ExampleModel, :savable => false)
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