require File.join(File.dirname(__FILE__), "/../spec_helper")

class Model
  
end

describe "build_stubs" do
  context ":as => :valid (default)" do
    context "class methods" do
      describe "find()" do
        it "returns a stubbled instance if given the right id" do
          model = build_stubs(Model)
          Model.find(model.id).should equal(model)
        end

        it "raises ActiveRecord::RecordNotFound with the wrong id" do
          model = build_stubs(Model)
          lambda do
            Model.find(model.id - 1)
          end.should raise_error(ActiveRecord::RecordNotFound)
        end

        it "returns a stubbled instance when given :id => the same id passed to find" do
          model = build_stubs(Model, :id => "37")
          Model.find("37").should equal(model)
        end

        it "raises ActiveRecord::RecordNotFound given :id => the wrong ID" do
          model = build_stubs(Model, :id => "37")
          lambda do
            Model.find("42")
          end.should raise_error(ActiveRecord::RecordNotFound)
        end

        it "returns a collection with :all" do
          model = build_stubs(Model)
          Model.find(:all).should == [model]
        end

        it "returns a collection with :all with additional args" do
          model = build_stubs(Model)
          Model.find(:all, :additional_arg => :whatever).should == [model]
        end
      end

      describe "new()" do
        it "returns an stubbled instance" do
          model = build_stubs(Model)
          Model.new.should equal(model)
        end
        
        it "assigns a nil id to the instance" do
          model = build_stubs(Model)
          Model.new.id.should be(nil)
        end
      end

      describe "all()" do
        it "returns a stubbled instance in an array" do
          model = build_stubs(Model)
          Model.all.should == [model]
        end
        
        it "assigns an id to that instance" do
          model = build_stubs(Model)
          Model.all.first.id.should be_between(1000,1100)
        end
      end
      
      describe "create()" do
        it "returns an stubbled instance" do
          instance = build_stubs(Model)
          Model.create.should equal(instance)
        end

        it "assigns an id to that instance" do
          model = build_stubs(Model)
          Model.create.id.should be_between(1000,1100)
        end
      end
      
      describe "create!()" do
        it "stubs create!" do
          instance = build_stubs(Model)
          Model.create!.should equal(instance)
        end

        it "assigns an id to that instance" do
          model = build_stubs(Model)
          Model.create!.id.should be_between(1000,1100)
        end
      end
    
    end

    context "instance methods" do
      def valid_model
        build_stubs(Model)
      end
      
      it "assigns a default id" do
        valid_model.id.should be_between(1000,1100)
      end
      
      it "assigns a diff default id each time" do
        build_stubs(Model).id.should == (build_stubs(Model).id - 1)
      end
      
      it "uses the assigned id instead of default" do
        build_stubs(Model, :id => "37").id.should == 37
      end
      
      it "returns true for save" do
        valid_model.save.should == true
      end

      it "returns true for save!" do
        valid_model.save!.should == true
      end

      it "returns true for update_attribute" do
        valid_model.update_attribute.should == true
      end

      it "returns true for update_attributes" do
        valid_model.update_attributes.should == true
      end

      it "returns true for update_attributes!" do
        valid_model.update_attributes!.should == true
      end
      
      it "returns true for valid?" do
        valid_model.valid?.should == true
      end
    end

  end

  context ":as => :invalid" do
    context "class methods " do
      describe "create!()" do
        it "raises ActiveRecord::RecordInvalid" do
          build_stubs(Model, :as => :invalid)
          expect { Model.create! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      
      describe "create()" do
        it "assigns a nil id to the instance" do
          build_stubs(Model, :as => :invalid)
          Model.create.id.should be(nil)
        end
      end
    end
    
    context "instance methods " do
      def invalid_model
        @invalid_model = build_stubs(Model, :as => :invalid)
      end

      it "returns false for save" do
        invalid_model.save.should_not be(true)
      end

      it "raises on save!" do
        lambda {
          invalid_model.save!
        }.should raise_error(ActiveRecord::RecordInvalid)
      end

      it "returns false for update_attribute" do
        invalid_model.update_attribute.should_not be(true)
      end

      it "returns false for update_attributes" do
        invalid_model.update_attributes.should_not be(true)
      end

      it "raises on update_attributes!" do
        lambda {
          invalid_model.update_attributes!
        }.should raise_error(ActiveRecord::RecordInvalid)
      end

      it "returns false for valid?" do
        invalid_model.valid?.should_not be(true)
      end
    end
  end
  
end

context "stubbing" do
  it "yields the instance" do
    stubbing(Model) do |model|
      model.should_not be_nil
    end
  end
  
  it "tears down the stubs" do
    model = nil
    stubbing(Model) do
      def reset
        $reset_called = true
      end
    end
    $reset_called.should be_true
  end
end
