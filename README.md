# YoukuVideo

解析出 YouKu 视频的 M3U8 播放地址

## 安装

把这行代码加到你的 Gemfile 中

```ruby
gem 'youkuVideo'
```

然后运行:

    $ bundle

或者你可以直接安装:

    $ gem install youkuVideo

## 使用方法

```
2.2.0 :007 > YoukuVideo::M3U8.getVideoURL("XNjgzMTU0MzU2", "hd3")
=> "http://pl.youku.com/playlist/m3u8?ctype=12&ep=dCaXGECKUs4G4iDagT8bZCu0cX4GXJZ0rEjP/LYHAMZuLerQmzbQwQ==%0A&ev=1&keyframe=1&oip=1899608454&sid=64329740673591237f599&token=2816&type=hd3&vid=XNjgzMTU0MzU2"
```

## 原理


由于优酷视频地址时间限制，在你访问本篇文章时，下面所属链接有可能已经失效，望见谅。

例：http://v.youku.com/v_show/id_XNzk2NTI0MzMy.html

1.获取视频vid
在视频url中标红部分。一个正则表达式即可获取。

```ruby
url = "http://v.youku.com/v_show/id_XNzk2NTI0MzMy.html"
vid = url.split("id_").last.split(".").first
```

2.获取视频元信息
```ruby
content = RestClient.get("http://v.youku.com/player/getPlayList/VideoIDS/#{vid}/Pf/4/ctype/12/ev/1")
json = JSON.parse(content)
ip = json["data"][0]["ip"]
ep = json["data"][0]["ep"]
```

上面显示的内容后面都会使用到。其中segs包含hd3,hd2,flv,mp4,3gp等各种格式，并且每种格式下均分为若干段。本次选用清晰度较高的hd2(视频格式为flv)

3.拼接m3u8地址
http://pl.youku.com/playlist/m3u8?ctype=12&ep={0}&ev=1&keyframe=1&oip={1}&sid={2}&token={3}&type={4}&vid={5}

以上共有6个参数，其中vid和oip已经得到，分别之前的vid和json文件中的ip字段，即(XNzk2NTI0MzMy和1991941296)，但是ep,sid,token需要重新计算(json文件中的ep值不能直接使用)。type即为之前选择的segs。

3.1计算ep,sid,token 计算方法单纯的为数学计算，下面给出计算的函数。三个参数可一次性计算得到。其中涉及到Base64编码解码知识。

```ruby
    def self.youkuEncoder(a, c, isToBase64)
      result = ""
      bytesR = []
      f,h,q = 0,0,0
      b = []
      256.times{|i| b[i]=i}
      while h < 256 do
        f = (f + b[h] + a[h % a.length].ord) % 256
        tmp = b[h]
        b[h] = b[f]
        b[f] = tmp
        h += 1
      end
      f,h,q = 0,0,0
      while q < c.length
        h = (h + 1) % 256
        f = (f + b[h]) % 256
        tmp = b[h]
        b[h] = b[f]
        b[f] = tmp
        bytes = [c[q].ord ^ b[(b[h] + b[f]) % 256]].pack "l"
        bytesR.push(bytes[0])
        result += bytes[0]
        q += 1
      end
      if isToBase64
        result = Base64.encode64(bytesR.join(""))
      end
      return result
    end

    def self.getEp(vid, ep)
      template1 = "becaf9be"
      template2 = "bf7e5f01"
      bytes = Base64.decode64(ep).split(//)
      tmp = youkuEncoder(template1, bytes, false)
      sid = tmp.split("_")[0]
      token = tmp.split("_")[1]
      whole = "#{sid}_#{vid}_#{token}"
      newbytes = whole.split("").map { |e| e.ord }
      epNew = youkuEncoder(template2, newbytes, true)
      return URI.encode(epNew), sid, token
    end
```

计算得到ep,token,sid分别为`cCaVGE6OUc8H4ircjj8bMiuwdH8KXJZ0vESH/7YbAMZuNaHQmjbTwg==`, `3825`, `241273717793612e7b085`。注意，此时ep并不能直接拼接到url中，需要对此做一下url编码URI.encode(epNew)。最终ep为`cCaVGE6OUc8H4ircjj8bMiuwdH8KXJZ0vESH%2f7YbAMZuNaHQmjbTwg%3d%3d`

3.2视频格式及清晰度
视频格式和选择的segs有密切关系。如本文选择的hd2，格式即为flv，下面是segs,视频格式和清晰度的对照。之前对此部分理解有些偏差，多谢削着苹果走路提醒。

```
"segs","视频格式","清晰度"
"hd3", "flv", "1080P"
"hd2", "flv", "超清"
"mp4", "mp4", "高清"
"flvhd", "flv", "高清"
"flv", "flv", "标清"
"3gphd", "3gp", "高清"
```

3.3拼接地址

最后的m3u8地址为

http://pl.youku.com/playlist/m3u8?ctype=12&ep=cCaVGE6OUc8H4ircjj8bMiuwdH8KXJZ0vESH%2f7YbAMZuNaHQmjbTwg%3d%3d&ev=1&keyframe=1&oip=996949050&sid=241273717793612e7b085&token=3825&type=hd2&vid=XNzk2NTI0MzMy

## Contributing

1. Fork it ( https://github.com/gonjay/youkuVideo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
