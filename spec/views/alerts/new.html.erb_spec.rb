require 'spec_helper'

describe "alerts/new.html.erb" do
  before(:each) do
    assign(:alert, stub_model(Alert,
      :title => "MyString",
      :amount => 1.5
    ).as_new_record)
  end

  it "renders new alert form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => alerts_path, :method => "post" do
      assert_select "input#alert_title", :name => "alert[title]"
      assert_select "input#alert_amount", :name => "alert[amount]"
    end
  end
end
