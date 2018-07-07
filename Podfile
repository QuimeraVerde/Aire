# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Aire' do
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# Pods for Aire
pod 'RxSwift', '~> 4.0'
pod 'RxCocoa', '~> 4.0'
pod 'SwiftGifOrigin', '~> 1.6.1'
pod 'UICircularProgressRing', '~> 3.0'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
