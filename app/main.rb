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

  def calculate(n)
      case n 
      when 0 then
        puts "0:#{n}"
        return 1
      when 2 then
        puts "1:#{n}"
        return 2
      else
        if n % 2 == 0 then
          puts "2:#{n}"
          sum = calculate(n - 1) + calculate(n - 2) + calculate(n - 3) + calculate(n - 4)
          return sum
        else
          #キャッシュにない場合はAPIを叩く
          if @cache[@seed][n.to_s] != nil then
          puts "3:#{n}"
            return @cache[@seed][n.to_s]
          else
          puts "4:#{n}"
            #APIを叩いてresultへ格納
            result = askServer(n)
            #cacheへ追加してcache.jsonに保存
            @cache[result["seed"]][result["n"]] = result["result"]
            File.open("./cache.json", 'w') do |file|
              JSON.dump(@cache, file)
            end
            return result["result"]
          end
        end
      end
  end
  public :calculate
end
def main(argv)
  begin 
    #パラメータがない場合は標準エラー出力にエラーメッセージを出力する
    if  argv[0] == nil || argv[1] == nil then
      raise "パラメータがセットされていません"
    end
  calculater = Calculater.new(argv[0])
  puts calculater.calculate(argv[1].to_i)
  rescue => e
    p e.message
  end
end
