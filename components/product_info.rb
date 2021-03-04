#encoding: windows-31j

require_relative "account_info"
require "csv"
def product_info(argv)
  info = account_info
  result = {}

  begin 
    info[:ap_file_dir] = argv if info[:is_ap_file_use_argv] =~ /y/i 
    ap_header = info[:ap_header_skip] =~ /y/i ? true : false
    CSV.foreach(info[:ap_file_dir], headers: ap_header) do |d|
      result[ d[ info[:ap_product_id_column] ] ] = {} if result[ d[ info[:ap_product_id_column] ] ] == nil
      result[ d[ info[:ap_product_id_column] ] ][:asin] = d[ info[:ap_asin_column] ]
    end

    info[:fp_file_dir] = argv if info[:is_fp_file_use_argv] =~ /y/i 
    fp_header = info[:fp_header_skip] =~ /y/i ? true : false
    CSV.foreach(info[:fp_file_dir], headers: fp_header) do |d|
      result[ d[ info[:fp_product_id_column] ] ] = {} if result[ d[ info[:fp_product_id_column] ] ] == nil
      result[ d[ info[:fp_product_id_column] ] ][:fnsku] = d[ info[:fp_fnsku_column] ]
    end

    info[:pq_file_dir] = argv if info[:is_pq_file_use_argv] =~ /y/i 
    pq_header = info[:pq_header_skip] =~ /y/i ? true : false
    CSV.foreach(info[:pq_file_dir], headers: true) do |d|
      result[ d[ info[:pq_product_id_column] ] ] = {} if result[ d[ info[:pq_product_id_column] ] ] == nil
      result[ d[ info[:pq_product_id_column] ] ][:quantity] = d[ info[:pq_quantity_column] ].to_i
    end
  rescue => e
    p e
    puts "error"
  end

  result
end

if __FILE__ == $0
  puts "product_info argv(filename)"
  p product_info(ARGV[0])
end
