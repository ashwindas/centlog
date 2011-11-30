require 'spec_helper'

describe "alerts/edit.html.erb" do
  before(:each) do
    @alert = assign(:alert, stub_model(Alert,
      :title => "MyString",
      :amount => 1.5
    ))
  end

  it "renders the edit alert form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => alerts_path(@alert), :method => "post" do
      assert_select "input#alert_title", :name => "alert[title]"
      assert_select "input#alert_amount", :name => "alert[amount]"
    end
  end
end
