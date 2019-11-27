# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'iCrave' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iCrave
  pod 'Cards'
  pod 'ActionSheetPicker-3.0'
  pod 'Charts'
  pod 'GradientProgressBar'
  pod 'Firebase/Analytics'

  # Troubleshoot Cards
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
        '$(FRAMEWORK_SEARCH_PATHS)'
      ]
    end
  end

end

target 'Widget' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iCrave
  pod 'GradientProgressBar'

end
