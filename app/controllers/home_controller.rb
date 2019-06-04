class HomeController < ApplicationController
  def top
    @shops = Shop.all
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "suumo_shop_list.csv", type: :csv
      end
    end
  end

  def empty
  end

  def scrape
    #URLの取得
    @url = params[:url]
    doc = Nokogiri::HTML( open(@url),nil,"utf-8")
    @urls = []
    @homes = []
    
    page_value = doc.xpath("//*[@id='js-sectionBody-main']/div[1]/div[2]/ol[@class='pagination-parts']/li[last()]/a/text()")
    page_value = page_value.to_s
    page_value = page_value.to_i
    
    for i in 1..page_value do
      @urls << "#{@url}&pn=#{i}"
    end

    doc = Nokogiri::HTML( open("#{@url}&pn=#{page_value}"),nil,"utf-8")
    homes = doc.xpath("//div[@class='property_unit-header']")
    scrape_value = (@urls.length - 1) * 30 + homes.length

    AddListJob.perform_later(@urls, scrape_value)

    flash[:success] = "#{scrape_value}件の格納を開始しました。すでに格納済みの場合は格納されません"
    redirect_to("/home/top")
  end

  def job_destroy
    @ques = Delayed::Job.all
    @ques.each do |que|
      que.destroy
    end
    flash[:success] = "格納を中止しました"
    redirect_to("/home/top")
  end

  def all_destroy
    @shops = Shop.all
    @shops.each do |shop|
      shop.destroy
    end
    flash[:success] = "すべて削除しました"
    redirect_to("/home/top")
  end
end
