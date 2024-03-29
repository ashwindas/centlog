class GroupsController < ApplicationController

  before_filter :authenticate_user!
  # GET /groups
  # GET /groups.xml
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups
  # GET /groups.xml
  def mygroups
    @groups = Group.find(:all, :conditions => {:owner_id => current_user.id})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])

    if params[:leave]
      if @group.users.include?(current_user)
      @group.users.delete(current_user)
      end
    end

    if params[:join]
      unless @group.users.include?(current_user)
      @group.users << current_user
      end
    end

    @members =  @group.users.where('id <> ?', @group.owner_id)

    if params[:new_user_email]
      new_member = User.find(:first, :conditions => ['email = ?', params[:new_user_email] ])
      if new_member
      @group.users << new_member
      redirect_to(@group, :notice => 'Member ' + params[:new_user_email] + ' added successfully')
      return
      else
      redirect_to(@group, :notice => 'Member ' + params[:new_user_email]  + ' not found')
      return
      end
    end

    @user_ids = Array.new
    @group.users.each do |u|
      @user_ids << u.id
    end
    @user_ids <<  @group.owner_id

    @transactions = Transaction.scoped(:conditions => ["user_id IN (?)", @user_ids ] )

    @total = @transactions.sum('amount')

    @transactions_paginated = @transactions.paginate(:page => params[:page], :per_page => 20)

    @pie_data = Hash.new
    User.all.each do |u|
      @pie_data[u.email] = u.transactions.sum('amount')
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end

  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to(@group, :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def find_post
    @post = current_user.posts.find(params[:id])
  end

end
