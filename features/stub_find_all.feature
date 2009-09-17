Feature: stub find all
  In order to stub a typical index action
  As a stubbler
  I want stubble to implicitly stub all() and find(:all)

  Background:
    Given "spec/controllers/things_controller_spec.rb" with
      """
      require 'spec_helper'

      describe ThingsController do
        describe "GET index" do
          it "assigns all things to @things" do
            stubbing(Thing) do |thing|
              get 'index'
              assigns[:things].should eql([thing])
            end
          end
        end
      end
      """

  Scenario: pass with all()
    Given "app/controllers/things_controller.rb" with
      """
      class ThingsController < ApplicationController
        def index
          @things = Thing.all
        end
      end
      """
    When I run "spec/controllers/things_controller_spec.rb"
    Then I should see "0 failures"

  Scenario: pass with find(:all)
    Given "app/controllers/things_controller.rb" with
      """
      class ThingsController < ApplicationController
        def index
          @things = Thing.find(:all)
        end
      end
      """
    When I run "spec/controllers/things_controller_spec.rb"
    Then I should see "0 failures"

  Scenario: fail on no index action
    Given "app/controllers/things_controller.rb" with
      """
      class ThingsController < ApplicationController
      end
      """
    When I run "spec/controllers/things_controller_spec.rb"
    Then I should see "No action responded to index"
    And I should see "1 failure"

@wip
  Scenario: fail on no access to model
    Given "app/controllers/things_controller.rb" with
      """
      class ThingsController < ApplicationController
        def index
        end
      end
      """
    When I run "spec/controllers/things_controller_spec.rb"
    Then I should see "No access to model"
    And I should see "1 failure"

  Scenario: fail on no assignment
    Given "app/controllers/things_controller.rb" with
      """
      class ThingsController < ApplicationController
        def index
          Thing.all
        end
      end
      """
    When I run "spec/controllers/things_controller_spec.rb"
    Then I should see "got nil"
    And I should see "1 failure"

