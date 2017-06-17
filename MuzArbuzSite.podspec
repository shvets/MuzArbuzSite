Pod::Spec.new do |s|
  s.name         = "MuzArbuzSite"
  s.version      = "1.0.0"
  s.summary      = "Framework for playing media from MuzArbuz.Com"
  s.description  = "Framework for playing media from MuzArbuz.Com."

  s.homepage     = "https://github.com/shvets/MuzArbuzSite"
  s.authors = { "Alexander Shvets" => "alexander.shvets@gmail.com" }
  s.license      = "MIT"
  s.source = { :git => "https://github.com/shvets/MuzArbuzSite.git", :tag => s.version }

  s.ios.deployment_target = "10.0"
  #s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "10.0"
  #s.watchos.deployment_target = "2.0"

  s.source_files = "Sources/**/*.swift"

  s.resource_bundles = {
    'com.rubikon.MuzArbuzSite' => ['Sources/**/*.{storyboard,strings,lproj}', ]
  }

  s.dependency 'SwiftyJSON', '~> 3.1.4'
  s.dependency 'WebAPI', '~> 1.0.8'
  s.dependency 'Runglish', '~> 1.0.0'
  s.dependency 'AudioPlayer', '~> 1.0.7'
  s.dependency 'TVSetKit', '~> 1.0.14'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
