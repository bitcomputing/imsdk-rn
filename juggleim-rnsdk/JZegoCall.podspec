require_relative 'ios/NativeSDKMetadata'

Pod::Spec.new do |s|
  s.name = 'JZegoCall'
  s.version = NativeSDKMetadata.version('JZegoCall')
  s.summary = 'JuggleIM Zego call plugin built from bitcomputing iOS source'
  s.homepage = 'https://github.com/bitcomputing/imsdk-ios'
  s.license = 'Apache-2.0'
  s.author = 'bitcomputing'
  s.source = { :git => 'https://github.com/bitcomputing/imsdk-ios.git', :commit => NativeSDKMetadata.commit }
  s.ios.deployment_target = '12.0'
  s.source_files = 'native/imsdk-ios/JZegoCall/JZegoCall/**/*.{h,m,mm}'
  s.public_header_files = 'native/imsdk-ios/JZegoCall/JZegoCall/JZegoCall.h'
  s.requires_arc = true
  s.prefix_header_contents = '#import <JuggleIM/JCallVideoDenoiseParams.h>'
  s.dependency 'JuggleIM', NativeSDKMetadata.version('JuggleIM')
  s.dependency 'ZegoExpressEngine', '3.22.0'
end
