Pod::Spec.new do |s|
  s.name             = "iOS"
  s.version          = "1.0.0"
  s.summary          = "Create Apple Applications with OneEngine"
  s.homepage         = "http://one.bzz.bz"
  s.license          = { :type => "MIT", :text => "MIT License" }
  s.author           = { "R" => "r@bzz.bz" }
  s.source           = { :git => "https://github.com/1Engine/OneApple.git", :tag => s.version }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'iOS/**/*.{swift,h}'
  s.resources = 'iOS/**/*.{storyboard,xcassets,wav,strings,stringsdict,db,xib}'

  s.module_name = 'iOS'

  s.dependency 'NVActivityIndicatorView', '4.7.0'
  s.dependency 'Reachability', '3.2'
  
end
