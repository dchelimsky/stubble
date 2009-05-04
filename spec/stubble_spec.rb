require File.join(File.dirname(__FILE__), "/spec_helper")

class Model
end

describe "stubble" do
  describe "class methods" do
    describe "find()" do
      it "returns a stubbled instance when given no args" do
        model = build_stubs(Model)
        Model.find("37").should equal(model)
      end

      it "returns a stubbled instance when given :id => the same id passed to find" do
        model = build_stubs(Model, :id => "37")
        Model.find("37").should equal(model)
      end
      
      it "returns a collection with :all" do
        model = build_stubs(Model)
        Model.find(:all).should == [model]
      end

      it "returns a collection with :all with additional args" do
        model = build_stubs(Model)
        Model.find(:all, :additional_arg => :whatever).should == [model]
      end

      it "raises RecordNotFound when given :id => the wrong id" do
        model = build_stubs(Model, :id => "37")
        lambda do
          Model.find("42")
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    it "stubs new on the class object, returning an stubbled instance" do
      model = build_stubs(Model)
      Model.new.should equal(model)
    end
    it "stubs all on the class object, returning an stubbled instance in an array" do
      model = build_stubs(Model)
      Model.all.should == [model]
    end
  end
  
  context "stubbing" do
    it "yields the instance" do
      stubbing(Model) do |model|
        model.should_not be_nil
      end
    end
  end
  
  context "creating" do
    it "stubs create" do
      instance = build_stubs(Model)
      Model.create.should == instance
    end
    
    it "stubs create!" do
      instance = build_stubs(Model)
      Model.create!.should == instance
    end
    
    it "raises if savable => false" do
      build_stubs(Model, :savable => false)
      expect { Model.create! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "instances" do
    context "default (savable)" do
      def savable
        @savable = build_stubs(Model)
      end
      
      it "returns true for save" do
        savable.save.should == true
      end

      it "returns true for save!" do
        savable.save!.should == true
      end

      it "returns true for update_attribute" do
        savable.update_attribute.should == true
      end

      it "returns true for update_attributes" do
        savable.update_attributes.should == true
      end

      it "returns true for update_attributes!" do
        savable.update_attributes!.should == true
      end
      
      it "returns true for valid?" do
        savable.valid?.should == true
      end
    end
    
    context "unsavable" do
      def unsavable
        @unsavable = build_stubs(Model, :savable => false)
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
      
      it "returns false for valid?" do
        unsavable.valid?.should be_false
      end
    end
  end
end