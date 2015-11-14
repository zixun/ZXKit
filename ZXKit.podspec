Pod::Spec.new do |s|
  s.name             = "ZXKit"
  s.version          = "0.0.3"
  s.summary          = "从CocoaChinaPlus App中抽离出来的Swift基础组件库."
  s.description      = <<-DESC
  从CocoaChinaPlus App中抽离出来的基础组件库. 纯Swift实现
  DESC
  s.homepage         = "https://github.com/zixun/ZXKit"
  s.license          = 'MIT'
  s.author           = { "zixun" => "chenyl.exe@gmail.com" }
  s.source           = { :git => "https://github.com/zixun/ZXKit.git", :tag => s.version.to_s } 

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/**/*.swift'
  s.resource_bundles = {
    'resource' => ['Resources/**/*.png','Resources/**/*.css','Resources/**/*.js']
  }
  s.frameworks = 'Foundation','UIKit'

  s.dependency 'Neon', '~> 0.0.3'
  s.dependency 'RxSwift', '~> 2.0.0-beta.2'
  s.dependency 'RxCocoa', '~> 2.0.0-beta.2'
  s.dependency 'RxBlocking', '~> 2.0.0-beta.2'
  s.dependency 'MBProgressHUD', '~> 0.9.1'

end