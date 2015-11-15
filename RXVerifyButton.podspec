


pod::Spec.new do |s|
  s.name     = "RXVerifyButton"
  s.version  = "0.1"
  s.license  = "MIT"
  s.homepage = "https://github.com/xzjxylophone/RXVerifyButton"
  s.author   = { 'Rush.D.Xzj' => 'xzjxylophoe@gmail.com' }
  s.social_media_url = "http://weibo.com/xzjxylophone"
  s.source   = { :git => 'https://github.com/xzjxylophone/RXVerifyButton.git', :tag => "v#{s.version}" }
  s.description = %{
    RXVerifyButton is a simple SMS count down.
  }
  s.source_files = 'RXVerifyButton/*.{h,m}'
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  s.platform = :ios, '5.0'
end



