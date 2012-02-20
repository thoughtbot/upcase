class ShopifyController < ApplicationController
  def order_paid
    if backbone_book?
      client = Octokit::Client.new(:login => "cpytel", :password => "cambridge")
      readers.each do |username|
        begin
          client.add_team_member(github_team_id, username)
        rescue Octokit::NotFound, Net::HTTPBadResponse => e
          Airbrake.notify(e)
        end
        sleep 0.2
      end
    end
    head :ok
  end

  private

  def backbone_book?
    params[:line_items].any? { |item| item[:sku] =~ /^BACKBONE/ }
  end

  def github_team_id
    73110
  end

  def readers
    params[:note_attributes].collect { |attribute| attribute[:value] if attribute[:name] =~ /reader/ && attribute[:value].strip.present? }.compact
  end
end
