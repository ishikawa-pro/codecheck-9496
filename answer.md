## 実装  
* Calculaterクラスを作成し、APIを叩いたり計算を行った。  
* 同じseedでは１時間に50回しかAPIが叩けないため、cache.jsonというAPIが返してきた値を保存しておくJSONファイルを作成して、以前叩いた値だったらAPIを叩かずにキャッシュを参照するようにした。  

## 発生した問題と対処法  
* キャッシュを参照する際に、キャッシュに値があるかうまく判定できておらず、APIを必ず叩きに行っていた  
  => 地道にデバッグして、問題コードを発見した。  
* 最初のテストケースは、終了ステータスが1かどうか判定してから、エラーの出力をしたかどうか判定していたが、それに気づけなかったためテストケースがパスできなかった。  
  => 最初のテストケースだけパスできなかったので、テスト用のコードを読んでどのように判定しているかを読み解いて問題を発見した。
