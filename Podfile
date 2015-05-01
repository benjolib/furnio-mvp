source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'

pod 'AFNetworking', '~> 2.5'
pod 'JSONModel', '~> 1.0'
pod 'SDWebImage', '~> 3.7'
pod 'UIColor+Hex', '~> 1.0'
pod 'Adjust', '~> 4.1'
pod 'Appirater', '~> 2.0'
pod 'DeepLinkSDK', '~> 0.2'
pod 'JSONModel', '~> 1.0'
pod 'UIColor+Hex', '~> 1.0'
pod 'AQSFacebookActivity', '~> 0.1'
pod 'AQSTwitterActivity', '~> 0.1'
pod 'MLPAutoCompleteTextField', '~> 1.5'
pod 'MMMaterialDesignSpinner', '~> 0.2'
pod 'FXBlurView', '~> 1.6'


# Disable logging of SDWebImagePrefetcher

post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        if target.name == "Pods-SDWebImage"
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'SD_LOG_NONE=1'
            end
        end
    end
end
