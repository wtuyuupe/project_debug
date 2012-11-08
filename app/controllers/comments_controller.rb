# Redmine - project management software
# Copyright (C) 2006-2012  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class CommentsController < ApplicationController
  default_search_scope :news
  model_object News
  before_filter :find_model_object
  before_filter :find_project_from_association
  before_filter :authorize

  def create
    raise Unauthorized unless @news.commentable?

    @comment = Comment.new
    @comment.safe_attributes = params[:comment]
    @comment.author = User.current
    if @news.comments << @comment
      flash[:notice] = l(:label_comment_added)
    end

    redirect_to :controller => 'news', :action => 'show', :id => @news
  end

  def destroy
    @news.comments.find(params[:comment_id]).destroy
    redirect_to :controller => 'news', :action => 'show', :id => @news
  end

  private

  # ApplicationController's find_model_object sets it based on the controller
  # name so it needs to be overriden and set to @news instead
  def find_model_object
    super
    @news = @object
    @comment = nil
    @news
  end
end