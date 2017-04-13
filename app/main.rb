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
 
    if @cache.has_key?(@seed) == false then
      @cache[result["seed"]] = Hash.new
    end
    @cache[result["seed"]][result["n"]] = result["result"]

    #cacheへ追加してcache.jsonに保存
    File.open("./cache.json", 'w') do |file|
      JSON.dump(@cache, file)
    end
    return result["result"].to_i
  end
  private :addCache

  def calculate(n)
      #puts n
      case n 
      when 0 then
        return 1
      when 2 then
        return 2
      else
        if n % 2 == 0 then
          sum = calculate(n - 1) + calculate(n - 2) + calculate(n - 3) + calculate(n - 4)
          return sum
        else
          #キャッシュにない場合はAPIを叩く
          if @cache.has_key?(@seed) == true then
            if @cache[@seed].has_key?(n.to_s) == true then
              return @cache[@seed][n.to_s]
            else
              return addCache(n)
            end
          else
            return addCache(n)
          end
        end
      end
  end
  public :calculate
end
#def main(argv)
  argv = ARGV
  if File.exist?("./cache.json") == false then
    File.open("cache.json", "w") do |file|
      JSON.dump({}, file)
    end
  end

  begin 
    #パラメータがない場合は標準エラー出力にエラーメッセージを出力する
    if  argv[0] == nil || argv[1] == nil then
      raise 
    end
  calculater = Calculater.new(argv[0])
  puts calculater.calculate(argv[1].to_i)
  rescue 
    puts "codecheck CLI should fail with status code 1"
#    return 1
  end
#end
