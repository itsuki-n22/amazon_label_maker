require "pdfkit"
require_relative "account_info"
PDFKit.configure do |config|
  config.wkhtmltopdf = __dir__ + "/../wkhtmltopdf/bin/wkhtmltopdf.exe" 
  config.wkhtmltopdf = account_info[:wkhtmltopdf_dir] if account_info[:wkhtmltopdf_dir]
    config.default_options = {
      :page_size => "Legal",
      :print_media_type => true
    }
end
