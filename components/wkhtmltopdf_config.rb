require "pdfkit"
PDFKit.configure do |config|
  config.wkhtmltopdf = __dir__ + "/../wkhtmltopdf/bin/wkhtmltopdf.exe"
    config.default_options = {
      :page_size => "Legal",
      :print_media_type => true
    }
end
