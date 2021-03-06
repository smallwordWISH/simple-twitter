class TweetsController < ApplicationController
  before_action :set_tweet, only:  [:like, :unlike, :destroy, :update]

  def index
    @users = User.order(followers_count: :desc, created_at: :desc).limit(10) # 基於測試規格，必須講定變數名稱，請用此變數中存放關注人數 Top 10 的使用者資料
    @tweets = Tweet.order(created_at: :desc).limit(20)

    @tweet = Tweet.new
  end

  def create    
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user

    if @tweet.save
      flash[:notice] = "Tweet was successfully created"
    else
      flash[:alert] = "Tweet was failed to create.  #{@tweet.errors.full_messages.to_sentence}"
    end
    redirect_to tweets_path
  end

  def update
    if !@tweet.update(tweet_params)
      flash[:alert] = "Tweet was failed to update. #{@tweet.errors.full_messages.to_sentence}"
    end
    # redirect_back(fallback_location: root_path)
  end

  def destroy
    if @tweet.user == current_user 
      @tweet.destroy

      if @tweet.present?
        flash[:notice] = "Tweet was successfully deleted."
      else
        flash[:alert] = "Tweet does not exist."
      end
      redirect_back(fallback_location: root_path)
      
    else
      flash[:alert] = "You are not authorized."
      redirect_to root_path
    end
  end

  def like
    Like.create(tweet: @tweet, user: current_user)
    @tweet.reload
    # redirect_back(fallback_location: root_path) Ajax設定之前
  end

  def unlike
    @likes = Like.where(tweet: @tweet, user: current_user)
    @likes.destroy_all
    @tweet.reload
    # redirect_back(fallback_location: root_path)  Ajax設定之前
  end

  def load
    if params[:current_id]
      @tweet = Tweet.find(params[:current_id])
      @tweets = Tweet.where( "created_at < ? and id < ?", @tweet.created_at, @tweet.id).order(id: :desc).limit(20)
      render json: {
          data: @tweets.map do |tweet| {
            id: tweet.id,
            html: render_to_string(partial: "share/tweet_item", locals: {tweet: tweet})
          }
        end
      }
    end
  end

  private 

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:description)
  end
end
