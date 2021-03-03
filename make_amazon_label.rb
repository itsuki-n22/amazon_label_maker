#encoding: windows-31j

require_relative "components/components"
require 'barby/barcode/qr_code'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

argv = ARGV[0]
output_dir = account_info[:output_dir].gsub("\\","/")
img_root_dir = account_info[:img_root_dir]
img_location_rule = account_info[:img_location_rule]
products_info = product_info(argv)

html = '<html><body>'

products_info.each do |product_id,v|
  # QRコードの作成
  uri = img_root_dir.gsub("\\","/") + "/"
  uri << img_location_rule.gsub("@id@",product_id).encode("utf-8")

  content = 'https://www.amazon.co.jp/dp/' + v[:asin] # QRコードの中身
  size    = 3 # QRコードのバージョン 1?40
  level   = :m # 誤り訂正レベル, l/m/q/h
  xdim    = 3  # 一番細いバーの幅
  qrcode = Barby::QrCode.new(content, size: size, level: level)
  qrsrc = qrcode.to_image(xdim: xdim).to_data_url

  content = v[:fnsku]
  barsrc = Barby::Code128B.new(content).to_image(xdim: xdim).to_data_url

  v[:quantity].times do
    html << "<div>"
    html << "<div><img src=#{uri}></div>"
    html << "<div>#{product_id}</div>"
    html << "<div><img src=#{qrsrc}></div>"
    html << "<div><img src=#{barsrc}></div>"
    html << "<div>#{v[:fnsku]}</div>"
    html << "</div>"
  end
end

html << '</body></html>'
File.open("test.html","w"){|f| f.write html }
kit = PDFKit.new(html, :page_size => 'Letter')
kit.to_file("test.pdf")



##############################
# QRコード生成

# PNGで出力
#png_file = 'output.png' # 出力PNGファイル名
#File.open(png_file, 'wb') do |f| 
#  f.write qrcode.to_png(xdim: xdim)
#end

# HTMLのimgタグ用のbase64で出力

