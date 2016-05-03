#Lwt_PageView.podspec
Pod::Spec.new do |s|
  s.name         = "Lwt_PageView"
  s.version      = "1.0.0"
  s.summary      = " a pageView in ios. "
  s.homepage     = "https://github.com/lwt211/Lwt_PageView"
  s.license      = 'MIT'
  s.author       = { " Li WenTao " => " lwt2ja@126.com " }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/lwt211/Lwt_PageView.git", :tag => s.version}
  s.source_files  = 'Lwt_PageView/*'
  s.requires_arc = true
  s.frameworks = 'Foundation', 'UIKit' 
end