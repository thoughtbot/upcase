module Playbook
  class Scraper
    def initialize(base_root, base_path)
      @base_url = base_root
      @base_path = base_path
    end

    def scrape
      get_all_paths.each do |path|
        playbook_page = Playbook::Page.new(File.join(@base_url + path))
        playbook_page.save_as_article
      end
    end

    private

    def get_all_paths
      homepage = Nokogiri::HTML(open(@base_url + @base_path))
      homepage.search("nav.global ul ul li a").map do |link| 
        link.attribute("href").to_s
      end
    end
  end
end
