#
# Be sure to run `pod lib lint CWShare.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CWShare'
  s.version          = '0.1.0'
  s.summary          = '基于微信、微博、QQ的SDK的二次封装，简单，方便，一键分享。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#  s.description      = <<-DESC
#TODO: Add long description of the pod here.
#                       DESC

  s.homepage         = 'https://github.com/ChrisWang115/CWShare'
  # s.screenshots      = 'admin.imdota.com/screenshot2.jpeg'
  s.license          = { :type => 'MIT'}
  s.author           = { 'ChrisWang115' => 'antjun@126.com' }
  s.source           = { :git => 'https://github.com/ChrisWang115/CWShare.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'CWShare/Classes/*.{h,m}'
  
  s.resource_bundles = {
      'CWShare' => ['CWShare/Assets/*.xcassets']
  }

  s.public_header_files = 'CWShare/Classes/CWShare.h'
  s.frameworks = 'UIKit', 'Foundation', 'QuartzCore'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'WeiboSDK'
  s.dependency 'Tencent_SDK'
  s.dependency 'WeChat_SDK'

end