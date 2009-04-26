require File.join(File.dirname(__FILE__), "/spec_helper")

class Model
end

describe "stubble" do
  describe "class methods" do
    describe "find()" do
      it "returns a stubbled instance when given no args" do
        model = stubble(Model)
        Model.find("37").should equal(model)
      end

      it "returns a stubbled instance when given :id => the same id passed to find" do
        model = stubble(Model, :id => "37")
        Model.find("37").should equal(model)
      end

      it "raises RecordNotFound when given :id => the wrong id" do
        model = stubble(Model, :id => "37")
        lambda do
          Model.find("42")
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    it "stubs new on the class object, returning an stubbled instance" do
      model = stubble(Model)
      Model.new.should equal(model)
    end
    it "stubs all on the class object, returning an stubbled instance in an array" do
      model = stubble(Model)
      Model.all.should == [model]
    end
  end
  
  context "creating" do
    it "yields the instance" do
      yielded_instance = nil
      assigned_instance = stubble(Model) {|yielded_instance|}
      yielded_instance.should equal(assigned_instance)
    end
  end

  describe "instances" do
    context "default (savable)" do
      def savable
        @savable = stubble(Model)
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
        @unsavable = stubble(Model, :savable => false)
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