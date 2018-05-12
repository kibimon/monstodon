Nokogiri::XML::Builder.new do |xml|
  xml.XRD(xmlns: 'http://docs.oasis-open.org/ns/xri/xrd-1.0') do
    xml.Subject @account.to_webfinger_s
    case @account
    when Monstodon::Mon, Monstodon::Route
      xml.Alias TagManager.instance.full_url_for(@account)
    when Monstodon::Trainer
      xml.Alias TagManager.instance.url_for(@account)
      xml.Alias TagManager.instance.full_url_for(@account)
    end
    xml.Link(rel: 'http://webfinger.net/rel/profile-page', type: 'text/html', href: TagManager.instance.url_for(@account))
    xml.Link(rel: 'http://schemas.google.com/g/2010#updates-from', type: 'application/atom+xml', href: OStatus::TagManager.instance.uri_for(@account, format: 'atom'))
    xml.Link(rel: 'self', type: 'application/activity+json', href: ActivityPub::TagManager.instance.uri_for(@account))
    xml.Link(rel: 'salmon', href: api_salmon_url(@account.id))
    xml.Link(rel: 'magic-public-key', href: "data:application/magic-public-key,#{@account.magic_key}")
    xml.Link(rel: 'http://ostatus.org/schema/1.0/subscribe', template: "#{authorize_follow_url}?acct={uri}")
  end
end.to_xml
