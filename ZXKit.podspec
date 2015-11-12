Pod::Spec.new do |s|
  s.name             = "ZXKit"
  s.version          = "0.0.1"
  s.summary          = "从CocoaChinaPlus App中抽离出来的Swift基础组件库."
  s.description      = <<-DESC
  从CocoaChinaPlus App中抽离出来的基础组件库. 
  DESC
  s.homepage         = "https://github.com/zixun/ZXKit"
  s.license          = 'MIT'
  s.author           = { "zixun" => "chenyl.exe@gmail.com" }
  s.source           = { :git => "https://github.com/zixun/ZXKit.git", :tag => s.version.to_s } 

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'ZXKit/Source/*'
  # s.resources = 'ZXKit/Resources'

  s.frameworks = 'Foundation','UIKit'

  end