# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'youkuVideo/version'

Gem::Specification.new do |spec|
  spec.name          = "youkuVideo"
  spec.version       = YoukuVideo::VERSION
  spec.authors       = ["GonJay"]
  spec.email         = ["me@gonjay.com"]
  spec.summary       = %q{解析出 YouKu 视频的 M3U8 播放地址}
  spec.description   = %q{通过网页或者 vid 解析出 YouKu 视频的 M3U8 播放地址}
  spec.homepage      = "https://github.com/gonjay/YoukuVideo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
