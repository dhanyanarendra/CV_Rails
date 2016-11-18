class GetPledgesJsonBuilder
  def initialize(user, pledge)
      @user = user
      @pledge = pledge
      @response = {}
      @result = {}
  end

  def build_get_pledges
    @response = []
    @pledge.each do |pledge|
      @response << build_feed(pledge)
    end
    @response
  end

  def build_feed(pledge)
    feed = pledge.feed
    campaign = feed.campaign.candidate_name if (feed.present? && feed.campaign.present?)
    @result = pledge.as_json
    @result[:feed] = feed.as_json
    @result[:campaign] = campaign.as_json
    @result
  end
end
