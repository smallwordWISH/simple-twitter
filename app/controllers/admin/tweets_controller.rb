class Admin::TweetsController < Admin::BaseController
  def index
    @tweets = Tweet.order(created_at: :desc).page(params[:page]).per(10)
  end

  def destroy
    @tweet = Tweet.find(params[:id])

    @tweet.destroy

    if @tweet.present?
      flash[:notice] = "tweet(#{@tweet.id}) was successfully deleted."
    else
      flash[:alert] = "tweet(#{@tweet.id}) does not exist."
    end
    
    redirect_to admin_root_path
  end
end
