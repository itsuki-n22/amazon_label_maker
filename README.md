利用条件： windows10 ※ruby が利用できる状態であることが必要です。  
  
## 手順
0.準備  
setup.batを起動すると必要な gemをinstallできます。  
その後 wkhtmltopdf をダウンロードして、このディレクトリにフォルダごと配置します。  
デフォルトではこのディレクトリから wkhtmltopdf/bin/wkhtmltopdf.exe に wkhtmltopdf.exeが配置されていると思いますが、そうでない場合、  
このディレクトリからの配置場所を setting/info.txt 内の以下の行に配置されている位置を記述してください。  
  
記入例：  
wkhtmltopdf_dir: wkhtmltopdf/bin/wkhtmltopdf.exe  
  
1.セッティング  
setting/info.txt で設定をします。  
data: という形式の項目が複数あるので、: の右側に値を指定します。 :の左側は削除や変更をしないでください。  
記入例は後述します。  
  
2.実行   
コマンドプロンプトから   
`make_amazon_label [CSVfile]`   
を実行してください。  
  
  
  

## setting/info.txtの書き方
以下、1.のsetting/info.txtの書き方を説明します。  
  
■PDFファイルを出力するディレクトリ■   
output_filename で作成するファイル名を指定できます。  
hoge と記述することで hoge.pdfが作製されます。  
output_dirではどこにPDFファイルを作成するか指定できます。  
  
例：  
output_dir: C:\Users\デスクトップ  
output_filename: amazon_label  
  
  
  
■商品の管理IDとASINが同時に掲載されているcsvファイルに対する設定■  
is_ap_file_use_argvを "y" とすることで、プログラム実行時の第一引数にあてたファイルをその対象ファイルとします。  
そうでない場合、ap_file_dir に対象のファイルを指定してください。   
asin_column ファイル内のasin が何列目にあるかを半角数字で指定してください  
product_id_column ファイル内の管理ID が何列目にあるかを半角数字で指定してください  
header_skip CSVファイルにヘッダが存在する場合、 "y" と入力します。  
以下、ほかのcsvファイルに対する設定も同様です。  
  
  
例：  
  
is_ap_file_use_argv: y  
ap_file_dir:   
ap_asin_column: 2  
ap_product_id_column: 1  
ap_header_skip: y  
   
■商品の管理IDとFNSKUが同時に掲載されているcsvファイルに対する設定  
上述の仕組みと同じです。  
fp_fnsku_column には fnskuの記載された列番号を入力します。  
  
例：  
  
is_fp_file_use_argv: y  
fp_file_dir:  
fp_fnsku_column: 9  
fp_product_id_column: 1  
fp_header_skip: y  
  
  
■商品の管理IDとプリント数が同時に掲載されているcsvファイルに対する設定  
上述の仕組みと同じです。  
pq_quantity_column には 印刷枚数の記載された列番号を入力します。  
  
例：    
  
is_pq_file_use_argv: y  
pq_file_dir:  
pq_quantity_column: 7  
pq_product_id_column: 1  
pq_header_skip: y  
  
■画像の取得に対する設定  
img_root_dir は web上のURLのディレクトリを指定してください  
例： http://hoge/files/images  
  
img_location_rule は画像の場所の指定の仕方を設定。  
@id@は商品の管理ID。これを使って画像の場所を指定できます。  
例： http://hoge/files/images/p1/p1-default.jpg  
にあれば  
@id@/@id@-default.jpg  
と記入  
  

例：  
  
img_root_dir: http://hoge/files/images/  
img_location_rule: @id@-s.jpg  
