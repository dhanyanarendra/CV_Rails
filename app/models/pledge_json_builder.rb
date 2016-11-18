class PledgeJsonBuilder
  def initialize(user, feed, pledge)
      @user = user
      @feed = feed
      @pledge = pledge
      @response = {}
      @result = {}
  end

  def build_pledges
    @result = @pledge.as_json
    @result[:feed] = @feed.as_json
    @result[:feed][:pledge_status] = (@feed && @feed.pledges.present? && @feed.pledges.where('user_contributor_id=? AND pledged=?', @user.id, true)).present? ? true : false
    @result
  end
end
