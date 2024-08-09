require "sinatra/base"
require "capybara_discoball"

class FakeWistia < Sinatra::Base
  get "/oembed.json" do
    headers "Access-Control-Allow-Origin" => "*"
    {
      html: "<iframe class='wistia_embed'></iframe>",
      thumbnail_url: "https://embed-ssl.wistia.com",
      duration: 120
    }.to_json
  end

  get "/medias.json" do
    page = params.fetch("page", 1).to_i
    limit = params.fetch("limit", 2).to_i
    paginate(
      collection: medias,
      page: page,
      limit: limit
    )
  end

  get "/medias/:id.json" do
    media.merge(hashed_id: params[:id]).to_json
  end

  def media
    {
      name: "humans present refactoring",
      type: "Video",
      duration: 4236.57,
      hashed_id: "91c694636a",
      status: "ready",
      project: {
        id: 133321,
        name: "Human Presents Refactoring",
        hashed_id: "8a28fa23f6"
      }
    }
  end

  def medias
    [
      {
        id: 1194803,
        name: "Vim for Rails Developers",
        type: "Video",
        duration: 3600.05,
        hashed_id: "947f4c35d9",
        section: "Vim for Rails Developers",
        project: {
          id: 130407,
          name: "Vim-related",
          hashed_id: "a70b2f2ee5"
        }
      },
      {
        id: 1211825,
        name: "chrome-dev-tools.mov",
        type: "Video",
        duration: 630,
        hashed_id: "04ccec11ed",
        status: "ready",
        project: {
          id: 133307,
          name: "Chrome Developer Tips",
          hashed_id: "b0f6587735"
        }
      },
      {
        id: 1211765,
        name: "humans present tmux",
        type: "Video",
        duration: 1593,
        hashed_id: "18c640ef8f",
        status: "ready",
        project: {
          id: 133293,
          name: "Humans Present TMUX medium",
          hashed_id: "03dfc83301"
        }
      }
    ]
  end

  def paginate(collection:, page:, limit:)
    starting_index = (page - 1) * limit
    if starting_index > (collection.size / limit) + 1
      "[]"
    else
      collection[starting_index..-1]
        .take(limit)
        .to_json
    end
  end
end

FakeWistiaRunner = Capybara::Discoball::Runner.new(FakeWistia) do |server|
  url = "http://#{server.host}:#{server.port}"
  ENV["WISTIA_HOST"] = url
  ENV["WISTIA_API_HOST"] = url
end
