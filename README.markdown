= ezormocks

* http://github.com/dchelimsky/ezormocks

== DESCRIPTION:

Tools to make mocking and stubbing ORM models just a little bit easier.

Pronounced "Easier Mocks", but contrived from Easy ORM Mocks

== GOALS:

Short term goal is to support ActiveRecord with RSpec's mocks because that's
what we're using on the project I'm working on right now.

Midterm goal is to evolve an ass-kickingly simple API to make it easier to mock and stub general concepts like the creation, saving and updating ORM models without worrying about the details of which specific methods are being called when.

Long term goal is to create an adapter API to easily support the same mocking API for multiple ORMs, mock frameworks and app frameworks.

== FEATURES/PROBLEMS:

* Currently just a gleam in my eye
* Supports very simple stuff for ActiveRecord / RSpec's mocks

== SYNOPSIS:

By default, ezormocks are findable, and savable.

The following examples will both pass if the controller's update action uses #find with any of:
* update_attribute + (save || save!)
* update_attributes
* update_attributes!

  describe "things" do
    context "successful PUT"
      it "redirects to the things index" do
        ezormock(Thing)
        post :update
        response.should redirect_to(things_path)
      end
    end

    context "successful PUT"
      it "re-renders the edit page" do
        ezormock(Thing, :savable => false)
        post :update
        response.should render_template('edit')
      end
    end
  end

== REQUIREMENTS:

* activerecord

== INSTALL:

  $ git clone git://github.com/dchelimsky/ezormock.git
  $ cd ezormock
  $ rake gem
  $ rake install_gem

== LICENSE:

(The MIT License)

Copyright (c) 2008 David Chelimsky

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.