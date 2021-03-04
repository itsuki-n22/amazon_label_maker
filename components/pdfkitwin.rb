require_relative "wkhtmltopdf_config"
class PDFKitWin < PDFKit
  def command(path = nil)
    args = @renderer.options_for_command
    shell_escaped_command = [executable, OS::shell_escape_for_os(args)].join ' '
    input_for_command = @source.to_input_for_command
    output_for_command = path.encode("utf-8") 
    "#{shell_escaped_command} #{input_for_command} #{output_for_command}"
  end
end
