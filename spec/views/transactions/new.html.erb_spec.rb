require 'spec_helper'

describe "transactions/new.html.erb" do
  before(:each) do
    assign(:transaction, stub_model(Transaction,
      :user_id => 1,
      :amount => 1.5,
      :location => "MyString",
      :description => "MyString",
      :tag => "MyString"
    ).as_new_record)
  end

  it "renders new transaction form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => transactions_path, :method => "post" do
      assert_select "input#transaction_user_id", :name => "transaction[user_id]"
      assert_select "input#transaction_amount", :name => "transaction[amount]"
      assert_select "input#transaction_location", :name => "transaction[location]"
      assert_select "input#transaction_description", :name => "transaction[description]"
      assert_select "input#transaction_tag", :name => "transaction[tag]"
    end
  end
end
