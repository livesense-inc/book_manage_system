class TopController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  require 'logger'

  def index
    json = stub_book_api()
    book_info = JSON.parse(json)
    logger.debug(book_info[0]['summary']['title'])
  end

  def confirm
    if validate(params[:isbn_number])
      render "top/index"
    end
  end

  private
  def validate(isbn_number)
    if isbn_number = (str =~ /\A[0-9]+\z/)
      if isbn_number..to_s.length == 10 || isbn_number..to_s.length == 13
        false
      end
    end
    true
  end


  def send_slack(book_info, employee_number)
    uri = URI.parse("https://hooks.slack.com/services/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")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.request_uri)
    logger.debug(uri.request_uri)

    req["Content-Type"] = "application/json"
    data =
        {
            "text" => "社員番号:#{employee_number}\nタイトル:hogehoge",
        }.to_json
    req.body = data
    res = http.request(req)
    logger.debug(res.code)
    logger.debug(res.msg)
    logger.debug(res.body)
  end

  def exec_book_info_api()
  end

  def stub_book_api()
    '[{"onix":{"RecordReference":"9784063879179","NotificationType":"03","ProductIdentifier":{"ProductIDType":"15","IDValue":"9784063879179"},"DescriptiveDetail":{"ProductComposition":"00","ProductForm":"BA","ProductFormDetail":"B110","Collection":{"CollectionType":"10","TitleDetail":{"TitleType":"01","TitleElement":[{"TitleElementLevel":"02","TitleText":{"collationkey":"アフタヌーンKCコミックス","content":"アフタヌーンKC"}}]}},"TitleDetail":{"TitleType":"01","TitleElement":{"TitleElementLevel":"01","TitleText":{"collationkey":"アマアマトイナズマ1","content":"甘々と稲妻（1）"}}},"Contributor":[{"SequenceNumber":"1","ContributorRole":["A01"],"PersonName":{"collationkey":"アマガクレ ギド","content":"雨隠 ギド"}}],"Language":[{"LanguageRole":"01","LanguageCode":"jpn"}],"Extent":[{"ExtentType":"11","ExtentValue":"192","ExtentUnit":"03"}],"Subject":[{"SubjectSchemeIdentifier":"78","SubjectCode":"9979"},{"SubjectSchemeIdentifier":"20","SubjectHeadingText":"男性にもオススメ;ヒューマンドラマ;その他;;;料理;父娘;子育て;教え子;愛情;;;;;;;;;;"}],"Audience":[{"AudienceCodeType":"22","AudienceCodeValue":"00"}]},"CollateralDetail":{"TextContent":[{"TextType":"02","ContentAudience":"00","Text":"料理が苦手な男やもめの高校教師・犬塚は、ひょんなことから教え子・小鳥と、一緒にごはんを作って娘と３人で食べることに！！"},{"TextType":"03","ContentAudience":"00","Text":"妻を亡くし、ひとりで娘の子育てに奮戦する数学教師・犬塚。料理が苦手で小食で味オンチな彼は、ひょんなことから教え子・飯田小鳥と、一緒にごはんを作って娘と３人で食べることに！！ 月刊「good！アフタヌーン」誌上で連載開始当初から話題沸騰！　愛娘＆女子高生と囲む、両手に花の食卓ドラマ、開幕です!!  「このマンガがすごい！２０１４」オトコ編第8位にランクイン！！"},{"TextType":"04","ContentAudience":"00","Text":"その1　制服とどなべごはん\nその2　豚汁とみせあかり\nその3　つむぎとおまたせのハンバーグ\nその4　ＧＷとおべんとう\nその5　お父さん屋さんのかぜんときスペシャル\nもうすぐ高校生"}],"SupportingResource":[{"ResourceContentType":"01","ContentAudience":"01","ResourceMode":"03","ResourceVersion":[{"ResourceForm":"02","ResourceVersionFeature":[{"ResourceVersionFeatureType":"01","FeatureValue":"D502"},{"ResourceVersionFeatureType":"04","FeatureValue":"9784063879179.jpg"}],"ResourceLink":"https:\/\/cover.openbd.jp\/9784063879179.jpg"}]}]},"PublishingDetail":{"Imprint":{"ImprintIdentifier":[{"ImprintIDType":"19","IDValue":"06"},{"ImprintIDType":"24","IDValue":"2253"}],"ImprintName":"講談社"},"PublishingDate":[{"PublishingDateRole":"01","Date":"20130906"}]},"ProductSupply":{"SupplyDetail":{"ProductAvailability":"99","Price":[{"PriceType":"03","PriceAmount":"590","CurrencyCode":"JPY"}]}}},"hanmoto":{"datemodified":"2015-08-13 15:44:28","datecreated":"2015-08-13 15:44:28"},"summary":{"isbn":"9784063879179","title":"甘々と稲妻（1）","volume":"","series":"","publisher":"講談社","pubdate":"20130906","cover":"https:\/\/cover.openbd.jp\/9784063879179.jpg","author":"雨隠ギド／著"}}]'
  end
end
