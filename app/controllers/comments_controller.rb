class CommentsController < ApplicationController

  def create
    #PENDING paginación de comentarios
    commentable = Comment.find_commentable params[:comment][:commentable_type], params[:comment][:commentable_id]
    first_comment = commentable.comments.empty?
    
    @comment = commentable.comments.new(params[:comment])
    @comment.user_id = current_user.id unless current_user.nil?
    @comment.approved = !commentable.respond_to?("moderated") || !commentable.moderated || commentable.owner == current_user

    respond_to do |format|
      if @comment.save
        CommentMailer.deliver_new_comment_notification(@comment)
        if @comment.approved
          message = {:ok => I18n.t("tog_core.site.comment.added")}
        else
          message = {:warning => I18n.t("tog_core.site.comment.left_pending")}
        end
      else
        message = {:error => I18n.t("tog_core.site.comment.error_comenting")}
      end
      format.html { redirect_to request.referer }
      #FIXME cuando se añade el comentario aparece un bullet
      format.js {
        render :template => "comments/create.rjs", :locals => {:first_comment => first_comment, :message => message}
      }
    end
  end

  def remove
    comment = Comment.find params[:id]

    if admin? || comment.commentable.owner == current_user
      if comment.destroy
        flash[:ok] = I18n.t("tog_core.site.comment.removed")
      else
        flash[:error] = I18n.t("tog_core.site.comment.error_removing")
      end
    else
      flash[:error] = I18n.t("tog_core.site.comment.error_removing")
    end

    redirect_to request.referer
  end

  def approve
    comment = Comment.find params[:id]

    if admin? || comment.commentable.owner == current_user
      comment.approved = true
      if comment.save
        flash[:ok] = I18n.t("tog_core.site.comment.approved")
      else
        flash[:error] = I18n.t("tog_core.site.comment.error_approving")
      end
    else
      flash[:error] = I18n.t("tog_core.site.comment.error_approving")
    end

    redirect_to request.referer
  end

end
