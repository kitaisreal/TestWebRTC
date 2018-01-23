# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

pre_install do |installer|
Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end
target 'AppRTCDemo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  inhibit_all_warnings!
  use_frameworks!
  pod 'ReactiveCocoa', '~> 7.0'
  pod 'libjingle_peerconnection'
  pod 'SocketRocket'
  pod 'Starscream', '~> 3.0.2'
  # Pods for AppRTCDemo
  
  target 'AppRTCDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AppRTCDemoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
