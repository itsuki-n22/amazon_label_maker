#encoding: windows-31j
require "csv"
def account_info
  hash = {}
  setting_file_dir = '/../setting/'
  if Dir.glob(__dir__ + "/../debug").empty? == false
    setting_file_dir = '/../debug/' 
    puts "debug mode"
  end
  File.open(__dir__ + setting_file_dir + "info.txt").read.each_line do |line|
    case line
    when /output_dir:/
      hash[:output_dir] = line.split("output_dir:").last.strip
    when /is_ap_file_use_argv:/
      hash[:is_ap_file_use_argv] = line.split("is_ap_file_use_argv:").last.strip
    when /ap_file_dir:/
      hash[:ap_file_dir] = line.split("ap_file_dir:").last.strip
    when /ap_asin_column:/
      hash[:ap_asin_column] = line.split("ap_asin_column:").last.strip.to_i - 1
    when /ap_product_id_column:/
      hash[:ap_product_id_column] = line.split("ap_product_id_column:").last.strip.to_i - 1
    when /ap_header_skip:/
      hash[:ap_header_skip] = line.split("ap_header_skip:").last.strip
    when /is_fp_file_use_argv:/
      hash[:is_fp_file_use_argv] = line.split("is_fp_file_use_argv:").last.strip
    when /fp_file_dir:/
      hash[:fp_file_dir] = line.split("fp_file_dir:").last.strip
    when /fp_fnsku_column:/
      hash[:fp_fnsku_column] = line.split("fp_fnsku_column:").last.strip.to_i - 1
    when /fp_product_id_column:/
      hash[:fp_product_id_column] = line.split("fp_product_id_column:").last.strip.to_i - 1
    when /fp_header_skip:/
      hash[:fp_header_skip] = line.split("fp_header_skip:").last.strip
    when /is_pq_file_use_argv:/
      hash[:is_pq_file_use_argv] = line.split("is_pq_file_use_argv:").last.strip
    when /pq_file_dir:/
      hash[:pq_file_dir] = line.split("pq_file_dir:").last.strip
    when /pq_quantity_column:/
      hash[:pq_quantity_column] = line.split("pq_quantity_column:").last.strip.to_i - 1
    when /pq_product_id_column:/
      hash[:pq_product_id_column] = line.split("pq_product_id_column:").last.strip.to_i - 1
    when /pq_header_skip:/
      hash[:pq_header_skip] = line.split("pq_header_skip:").last.strip
    when /img_root_dir:/
      hash[:img_root_dir] = line.split("img_root_dir:").last.strip
    when /img_location_rule:/
      hash[:img_location_rule] = line.split("img_location_rule:").last.strip
    end
  end

  begin
    if !hash[:stock_file].nil? &&
       hash[:stock_file] != "" &&
       !hash[:stock_id_column].nil? &&
       hash[:stock_id_column] != "" &&
       !hash[:stock_num_column].nil? &&
       hash[:stock_num_column] != "" 
      stock_num_columns = hash[:stock_num_column].split(",")
      CSV.foreach(hash[:stock_file]) do |f|
        stock_num = 0
        stock_num_columns.each do |column|
          stock_num += f[ column.to_i ].to_i if f[ column.to_i ]
        end
        hash[:stock_num][ f[ hash[:stock_id_column].to_i ] ] = stock_num
      end
    end
  rescue => e
    puts e
    puts "在庫データを取得できませんでした"
  end

  begin 
    if hash[:fba_check] == "y" &&
       !hash[:fba_data_file].nil? &&
       hash[:fba_data_file] != "" &&
       !hash[:amazon_sku_column].nil? &&
       hash[:amazon_sku_column] != "" &&
       !hash[:amazon_stock_column].nil? &&
       hash[:amazon_stock_column] != "" &&
       !hash[:amazon_company_id_column].nil? &&
       hash[:amazon_company_id_column] != "" &&
       !hash[:amazon_asin_column].nil? &&
       hash[:amazon_asin_column] != "" 

      asin_column = hash[:amazon_asin_column].to_i
      sku_column = hash[:amazon_sku_column].to_i
      company_id_column = hash[:amazon_company_id_column].to_i
      amazon_stock_column = hash[:amazon_stock_column].to_i

      CSV.foreach(hash[:fba_data_file]) do |f|
        hash[:fba_data][ f[ company_id_column ] ] = {}
        hash[:fba_data][ f[ company_id_column ] ][:asin] = f[ asin_column ]
        hash[:fba_data][ f[ company_id_column ] ][:sku] = f[ sku_column ]
        hash[:fba_data][ f[ company_id_column ] ][:amazon_stock] = f[ amazon_stock_column ]
      end
    end
  rescue => e
    puts e
    puts "FBA発送データを取得できませんでした"
  end

  hash
end

if __FILE__ == $0
  p account_info
end
