require 'will_paginate/array'



class TransactionsController < ApplicationController

  before_filter :authenticate_user!
  # GET /transactions
  # GET /transactions.xml
  def index

    @transactions = current_user.transactions(:order => "date DESC")

    @sub_title = "Showing all your expenses"

    if params[:search]
      @transactions = @transactions.scoped(:conditions => ['description LIKE ? OR tag LIKE ? OR location LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%"])
    @sub_title = "Found "
    @sub_title << @transactions.size.to_s
    @sub_title << " results matching with - '"
    @sub_title << params[:search]
    @sub_title << "'"
    end

    @total = @transactions.sum('amount')

    #Code below is for calculating information for the Pie chart
    tag_set = Set.new

    @transactions.each do |tran|
      tag_set << tran.tag
    end

    @pie_data = Hash.new

    tag_set.each do |tag|
      temp_trans = @transactions.where("tag = ?", tag)
      @pie_data[tag] = temp_trans.sum('amount')
    end

    #Code below is for calculating information for the Pie chart
    @transactions = @transactions.sort! { |a,b| a.date <=> b.date }

    @graph_data = Hash.new

    @transactions.each do |t|
      time = Time.parse(t.date.to_s).utc.to_i*1000
      if  @graph_data[time]
      @graph_data[time] += t.amount
      else
      @graph_data[time] = t.amount
      end
    end

    #Code below is for calculating information for the bar chart
    @bar_data = Hash.new { |h,v| h[v]= Hash.new }

    @transactions.each do |t|
      trans_tag = t.tag
      month = t.date.strftime("%B, %Y")
      if @bar_data[trans_tag]
        if @bar_data[trans_tag][month]
        @bar_data[trans_tag][month] += t.amount
        else
        @bar_data[trans_tag][month] = t.amount
        end
      else
      @bar_data[trans_tag] = Hash.new
      @bar_data[trans_tag][month] = t.amount
      end
    end

    @months_set = Set.new

    @transactions.each do |t|
      @months_set << t.date.strftime("%B, %Y")
    end

    @transactions_paginated = @transactions.paginate(:page => params[:page], :per_page => 50)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.xml
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.xml
  def new
    @transaction = Transaction.new

    @transactions = current_user.transactions
    #Code below is for calculating information for the Pie chart
    @tag_set = Set.new

    @transactions.each do |tran|
      @tag_set << tran.tag
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])

    @transactions = current_user.transactions
    #Code below is for calculating information for the Pie chart
    @tag_set = Set.new

    @transactions.each do |tran|
      @tag_set << tran.tag
    end

  end

  # POST /transactions
  # POST /transactions.xml
  def create

    @transaction  = current_user.transactions.build(params[:transaction])

    #@transaction = Transaction.new(params[:transaction])

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to(@transaction, :notice => 'Transaction was successfully created.') }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.xml
  def update
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.html { redirect_to(@transaction, :notice => 'Transaction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.xml
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to(transactions_url) }
      format.xml  { head :ok }
    end
  end

end
