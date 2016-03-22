@version = "0.01"
Pod::Spec.new do |s|
  s.name             = 'GhostPlusShare'
  s.version          = @version
  s.summary          = 'Ghost Plus Share Framework'
  s.description      = 'Ghost Plus Share Framework'
  s.homepage         = 'http://www.ghostplus.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'VANSTUDIO' => 'vanstudio@ghost-corps.com' }
  
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  
  framework_path = 'GhostPlusShare.framework'

  s.vendored_frameworks = ['Frameworks/GhostPlusShare.framework']
  
  #s.source           = { :http => 'http://developer.ghostplus.com/project/ghostplus_ios/GhostPlus-1.00.tar.gz', :flatten => true }
  s.source       = { :git => "https://github.com/vanstudio/GhostPlusShare-iOS.git", :tag => @version }
  
  s.source_files = []
  s.resources = ['Frameworks/GhostPlusShare.framework/Versions/A/Resources/GhostPlusShareResources.bundle']
  
  s.preserve_paths = []
  s.header_dir = 'GhostPlusShare'

  s.frameworks = ['GhostPlusShare', 'Social']
  #s.libraries = ['stdc++', 'z']
  
  #s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/TestGhostPlus"' }
  
  s.dependency 'GhostPlus'
  #s.dependency 'KakaoOpenSDK', :git => 'git@github.com:Posteet/KakaoOpenSDK.git'
end