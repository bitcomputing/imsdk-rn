require_relative 'ios/NativeSDKMetadata'

Pod::Spec.new do |s|
  s.name = 'JuggleIM'
  s.version = NativeSDKMetadata.version('JuggleIM')
  s.summary = 'JuggleIM core built from bitcomputing iOS source'
  s.homepage = 'https://github.com/bitcomputing/imsdk-ios'
  s.license = 'Apache-2.0'
  s.author = 'bitcomputing'
  s.source = { :git => 'https://github.com/bitcomputing/imsdk-ios.git', :commit => NativeSDKMetadata.commit }
  s.ios.deployment_target = '12.0'
  s.source_files = 'native/imsdk-ios/JuggleIM/JuggleIM/**/*.{h,m,mm,c,cc,cpp}'
  # Match the Public header build phase of the current upstream Xcode target.
  s.public_header_files = NativeSDKMetadata.public_headers
  s.project_header_files = 'native/imsdk-ios/JuggleIM/JuggleIM/vendor/**/*.h'
  # Unprefixed vendored SocketRocket headers collide with React Native's SocketRocket pod.
  s.exclude_files = [
    'native/imsdk-ios/JuggleIM/JuggleIM/vendor/SocketRocket/**/SR*.h',
    'native/imsdk-ios/JuggleIM/JuggleIM/vendor/SocketRocket/SocketRocket.h'
  ]
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"${PODS_TARGET_SRCROOT}/ios" "${PODS_TARGET_SRCROOT}/native/imsdk-ios/JuggleIM/JuggleIM/vendor/SocketRocket/**" $(inherited)'
  }
  s.prefix_header_contents = '#import "JuggleIMVendorPrefix.h"'
  # This one vendored C symbol is not prefixed upstream and otherwise duplicates
  # the same symbol in React Native's SocketRocket pod at link time.
  s.compiler_flags = '-DSRMaskBytesSIMD=JIMSRMaskBytesSIMD'
  # The upstream Xcode project compiles protobuf runtime and generated files without ARC.
  source_root = File.join(__dir__, 'native/imsdk-ios/JuggleIM/JuggleIM')
  s.requires_arc = Dir.glob(File.join(source_root, '**/*.{m,mm}')).reject do |path|
    path.include?('/vendor/protobuf/') || path.end_with?('.pbobjc.m')
  end.map { |path| path.delete_prefix("#{__dir__}/") }
  s.frameworks = 'Foundation', 'SystemConfiguration', 'Security'
  s.libraries = 'sqlite3', 'z'
end
