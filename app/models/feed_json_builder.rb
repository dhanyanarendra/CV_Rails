class FeedJsonBuilder
  def initialize(feed,user)
      @user = user
      @feeds = feed
      @response = {}
      @result = {}
  end

  def build_feed
    @response = []
    @feeds.each do |feed|
      @response << build_pledges(feed)
    end
    @response
  end

  def build_pledges(feed)
    @result = feed.as_json
    @result[:pledge_status] = (feed && feed.pledges.present? && feed.pledges.where('user_contributor_id=? AND pledged=?', @user.id, true)).present? ? true : false
    @result[:like_status] = feed.liked_by?(@user)
    @result[:created_by] = feed.user.first_name if feed.user.present?
    @result
  end
end
