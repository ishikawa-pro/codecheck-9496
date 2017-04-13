require 'net/http'
require 'json'

class Calculater
    attr_reader :seed
    attr_accessor :n, :cache

  def initialize(seed)
    @seed = seed
    #json形式で保存したcacheをロードしてHashへ格納
    File.open("./cache.json") do |file|
        @cache = JSON.load(file)
    end
  end

  def askServer(n)
    #パラメータを作成
    params = Array.new
    params.push("seed=" + @seed.to_s)
    params.push("&n=" + n.to_s)
  
    #urlを作成
    uri_str = 'http://challenge-server.code-check.io/api/recursive/ask?'
    params.each do |param|
      uri_str += param
    end
    uri = URI.parse(uri_str)
    
    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    
    #APIを叩いて結果をresponseへ代入
    response = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(request)
    end
    #結果をjsonにパースして格納
    return JSON.parse(response.body)
  end
  private :askServer

  def addCache(n)
    #APIを叩いてresultへ格納
    result = askServer(n)
 
    #cache.jsonにseedがあるか
    if @cache.has_key?(@seed) == false then
      #新しいseedをキーとしたハッシュを作成
      @cache[result["seed"]] = Hash.new
    end
    #nの結果を格納
    @cache[result["seed"]][result["n"]] = result["result"]

    #cacheへ追加してcache.jsonに保存
    File.open("./cache.json", 'w') do |file|
      JSON.dump(@cache, file)
    end
    return result["result"].to_i
  end
  private :addCache

  def calculate(n)
      #引数に応じて処理を分岐
      case n 
      when 0 then
        return 1
      when 2 then
        return 2
      else
        if n % 2 == 0 then
          #再帰呼び出し
          sum = calculate(n - 1) + calculate(n - 2) + calculate(n - 3) + calculate(n - 4)
          return sum
        else
          #キャッシュにない場合はAPIを叩く
          #seedはあるか？
          if @cache.has_key?(@seed) == true then
            #nのキャッシュがあるか?              
            if @cache[@seed].has_key?(n) == true then
              return @cache[@seed][n]
            else
              #APIを叩く
              return addCache(n)
            end
          else
            #APIを叩く
            return addCache(n)
          end
        end
      end
  end
  public :calculate
end

#テストの際にindex.rbを使わずに、直接main.rbを実行するようになったのでmain関数を廃止
#def main(argv)
  argv = ARGV

  #キャッシュ用ファイルのcache.jsonが無い場合は作成
  if File.exist?("./cache.json") == false then
    File.open("cache.json", "w") do |file|
      JSON.dump({}, file)
    end
  end

  begin 
    #パラメータがない場合は標準エラー出力にエラーメッセージを出力する
    if  argv[0] == nil || argv[1] == nil then
      raise "codecheck CLI should fail with status code 1" 
    end
  
  calculater = Calculater.new(argv[0])
  puts calculater.calculate(argv[1].to_i)

  #エラー処理
  rescue => e
    puts 1 
    
  end
#end
