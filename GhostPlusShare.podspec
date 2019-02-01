@version = "1.06"
Pod::Spec.new do |s|
  s.name             = 'GhostPlusShare'
  s.version          = @version
  s.summary          = 'Ghost Plus Share Framework'
  s.description      = 'Ghost Plus Share Framework'
  s.homepage         = 'http://www.ghostplus.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'VANSTUDIO' => 'vanstudio@ghost-corps.com' }
  
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  
  s.source       = { :git => "https://github.com/vanstudio/GhostPlusShare-iOS.git", :tag => @version }
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|
  	core.dependency 'GhostPlus'
  	core.header_dir = 'GhostPlusShare'
  	core.vendored_frameworks = ['Frameworks/GhostPlusShare.framework']
  	core.resource = 'Frameworks/GhostPlusShare.framework/Versions/A/Resources/GhostPlusShareResources.bundle'
  	core.frameworks = 'MessageUI'
  end
  
  s.subspec 'Facebook' do |facebook|
  	facebook.source_files = 'Classes/Services/Facebook/**/*.{h,m}'
  	facebook.dependency 'FBSDKCoreKit', '~> 4.33.0'		# (2018.06.12) 
  	facebook.dependency 'FBSDKShareKit', '~> 4.33.0'	# (2018.06.12) 
  	facebook.dependency 'GhostPlusShare/Core'
  end
  
  s.subspec 'Twitter' do |twitter|
  	twitter.pod_target_xcconfig = { 'CLANG_ENABLE_MODULES' => 'NO' }	# for TwitterCore module error
  	twitter.source_files = 'Classes/Services/Twitter/**/*.{h,m}'
  	twitter.dependency 'Fabric'
  	twitter.dependency 'TwitterKit', '~> 2.8.1'
  	twitter.dependency 'GhostPlusShare/Core'
  end
  
  s.subspec 'Kakao' do |kakao|
  	kakao.source_files = 'Classes/Services/Kakao/**/*.{h,m}'
    kakao.dependency 'GhostPlusShare/Core'
  	kakao.vendored_frameworks = ['Frameworks/KakaoOpenSDK.framework', 'Frameworks/KakaoCommon.framework', 'Frameworks/KakaoLink.framework', 'Frameworks/KakaoMessageTemplate.framework']	# (2018.06.12) 
    kakao.frameworks = 'UIKit'
  end
  
  s.subspec 'NaverBand' do |naverband|
  	naverband.source_files = 'Classes/Services/NaverBand/**/*.{h,m}'
    naverband.dependency 'GhostPlusShare/Core'
  end
end