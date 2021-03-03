#encoding: windows-31j
Dir.glob(__dir__ + "/*").each{|f| require_relative f unless f =~ %r{/components.rb} || f =~ %r{.rb.+} }

