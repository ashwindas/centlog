require 'spec_helper'

describe "alerts/show.html.erb" do
  before(:each) do
    @alert = assign(:alert, stub_model(Alert,
      :title => "Title",
      :amount => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
  end
end
