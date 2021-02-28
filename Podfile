# Uncomment the next line to define a global platform for your project
platform :ios, '13'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

target 'Random Pro' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Random Pro

pod 'SDWebImageSwiftUI'

end
