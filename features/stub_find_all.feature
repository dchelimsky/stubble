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

  Scenario: fail on no index action
    Given "app/controllers/things_controller.rb" with
      """
      class ThingsController < ApplicationController
      end
      """
    When I run "spec/controllers/things_controller_spec.rb"
    Then I should see "No action responded to index"
    And I should see "1 failure"

