class AddListJob < ApplicationJob
  queue_as :default

  def perform(urls, value)
    @count = 1
    urls.each do |url|
      open_url = open(url)
      html = Nokogiri::HTML(open_url,nil,"utf-8")

      #物件情報の取得
      homes = html.xpath("//div[@class='property_unit-header']")
      homes.each do |home|
        puts ''
        puts "#{@count}/#{value} 格納中..."
        
        #物件のURLを取得
        home_dir = home.xpath('string(h2/a/@href)')
          
        #取得したURLからさらに詳細な内容を取得
        home_url = 'https://suumo.jp' + home_dir
        home_html = Nokogiri::HTML(open(home_url),nil,"utf-8")
        
        #取り扱い元の企業または店舗の名前を取得
        shop_name = home_html.xpath("//td[@class='bdGrayB']/p[1]//text()").to_s
        if shop_name == ''
          shop_name = home_html.xpath("//a[@class='jscToiawaseSakiWindow']/text()").to_s
        end

        if Shop.exists?(name: shop_name)
          @count += 1
          puts '格納済みのため、スキップ'
          puts ''
          next
        end

        #取得したURLからさらに取り扱い元の詳細なページのHTMLを取得
        shop_url = home_html.xpath("string(//*[@id='topContents']/div[2]/div[2]/div/p[2]/input/@value)")

        if shop_url == ''
          shop_add = '取り扱い元の詳細な情報が記載されていません'
          shop_number = '電話番号が公開されていません'
        else
          shop_html = Nokogiri::HTML(open(shop_url),nil,"utf-8")

          #取り扱い元の住所を取得
          shop_add = shop_html.xpath("//td/text()").to_s

          #取り扱い元の電話番号を取得
          shop_number = shop_html.xpath("//*[@id='bkdt-shop-area']/div/ul/li[1]/em/text()").to_s
        end

        #取り扱い元の住所格納
        #@shop.address = shop_add

        #取り扱い元のホームページを取得
        shop_homepages = home_html.xpath("//li[@class='ic icArrowR pl10']")
        links = {}
        shop_homepages.each do |page|
          shop_homepage_name = page.xpath("a/text()").to_s
          shop_homepage = page.xpath("a/@href").to_s
          links[shop_homepage_name] = shop_homepage
        end

        #要素の保存
        @shop = Shop.new(name: shop_name, address: shop_add, phone_number: shop_number)

        links.each do |shop_homepage_name, shop_homepage|
          @shop.links.new(title: shop_homepage_name, url: shop_homepage)
        end

        @shop.save

        @count += 1
        puts '格納完了'
        puts ''

        sleep(1)
      end
    end
  end
end
