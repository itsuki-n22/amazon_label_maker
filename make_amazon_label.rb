#encoding: windows-31j

require_relative "components/components"
require 'barby/barcode/qr_code'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

argv = ARGV[0]
output_dir = account_info[:output_dir]
output_filename = account_info[:output_filename]
img_root_dir = account_info[:img_root_dir]
img_location_rule = account_info[:img_location_rule]
products_info = product_info(argv)

html = '<html><body><div class="container">'
html << '<style>'
html << File.open("setting/style.css").read
html << '</style>'

print "now processing."
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

  # バーコードの作成
  content = v[:fnsku]
  barsrc = Barby::Code128B.new(content).to_image(xdim: xdim).to_data_url

  # HTMLに変換
  v[:quantity].times do
    print "."
    html << "<div class='item'>"
    html << "<div class='wrap'>"
    html << "<div class='img'><img class='i_1' height='80px' width='80px' src=#{uri}><img class='i_2' src=#{qrsrc}></div>"
    html << "<div class='id'>#{product_id}</div>"
    html << "<div><img class='i_3' src=#{barsrc}></div>"
    html << "<div class='fnsku'>#{v[:fnsku]}</div>"
    html << "</div>"
    html << "</div>"
  end
end

html << '</div></div></body></html>'
File.open("#{output_dir}/#{output_filename}.html","w"){|f| f.write html }
puts "\nhtml file has been made"

options = {
  margin_top: "0.1in",
  margin_bottom: "0.1in",
  margin_right: "0in",
  margin_left: "0in",
  :page_size => 'A4' 
}

kit = PDFKitWin.new(html, options)
#kit.stylesheets << __dir__ + "/setting/style.css"
kit.to_file("#{output_dir}/#{output_filename}.pdf")
puts "\n #{output_filename}.pdf file has been made!"
