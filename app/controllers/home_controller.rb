class HomeController < ApplicationController
  def top
  end

  def scrape
    #URLの取得
    url = params[:url]
    html = Nokogiri::HTML(open(url),nil,"utf-8")

    #物件URLの取得
    homes = html.xpath("//div[@class='property_unit-header']")
    homes.each do |home|
        home_dir = home.xpath('string(h2/a/@href)')
        
        #取得したURLからさらに詳細な内容を取得
        home_url = 'https://suumo.jp' + home_dir
        home_html = Nokogiri::HTML(open(home_url),nil,"utf-8")

        #企業または店舗のページを取得
        shop_dir = home_html.xpath("string(//table[@class='mt15 bdGrayT bdGrayL bgWhite pCell10 bdclps wf']/tbody/tr[9]/td[1]/p[1]/a/@href)")
        shop_url = "https://suumo.jp" + shop_dir
        puts shop_url
    end
  end
end

