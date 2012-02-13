class ShopifyController < ApplicationController
  def order_paid
    if backbone_book?
      client = Octokit::Client.new(:login => "cpytel", :password => "cambridge")
      readers.each do |username|
        client.add_team_member(github_team_id, username)
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
    params[:note_attributes].collect { |attribute| attribute[:value] if attribute[:name] =~ /reader/ }.compact
  end
end
