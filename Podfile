platform :ios, '18.0'

target 'Todoey' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Todoey
  pod 'RealmSwift'
  pod 'SwipeCellKit'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.0'
    end
  end
end
