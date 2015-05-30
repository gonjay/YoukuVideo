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

## Contributing

1. Fork it ( https://github.com/gonjay/youkuVideo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
