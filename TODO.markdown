# To Do

* raise an error when updated w/ wrong attributes
* raise error when no attributes are updated
* ask the frameworks to verify their own mock expectations
* use a symbol for the model instead of :params

<pre>
describe ThingsController do
  describe "POST create" do
    it "creates a new post" do
      stubbing(Thing, :thing => {'these' => 'params'}) do
        post :create, :thing => {'these' => 'params'}
      end
    end
  end
end
</pre>