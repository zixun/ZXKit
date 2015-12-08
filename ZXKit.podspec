#
# Be sure to run `pod lib lint ZXKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ZXKit"
  s.version          = "0.1.0"
  s.summary          = "从CocoaChinaPlus App中抽离出来的Swift基础组件库."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
 从CocoaChinaPlus App中抽离出来的基础组件库. 纯Swift实现
                       DESC

  s.homepage         = "https://github.com/zixun/ZXKit"
  s.license          = 'MIT'
  s.author           = { "zixun" => "chenyl.exe@gmail.com" }
  s.source           = { :git => "https://github.com/zixun/ZXKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ZXKit' => ['Pod/Assets/**/*.png','Pod/Assets/**/*.css','Pod/Assets/**/*.js']
  }

  s.frameworks = 'Foundation','UIKit'

  s.dependency 'Neon', '~> 0.0.3'
  s.dependency 'RxSwift', '~> 2.0.0-beta.2'
  s.dependency 'RxCocoa', '~> 2.0.0-beta.2'
  s.dependency 'MBProgressHUD', '~> 0.9.1'

end
