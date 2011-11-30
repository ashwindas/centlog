require 'spec_helper'

describe "alerts/index.html.erb" do
  before(:each) do
    assign(:alerts, [
      stub_model(Alert,
        :title => "Title",
        :amount => 1.5
      ),
      stub_model(Alert,
        :title => "Title",
        :amount => 1.5
      )
    ])
  end

  it "renders a list of alerts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
