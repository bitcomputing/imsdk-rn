require 'json'
require_relative 'juggleim-rnsdk/ios/NativeSDKMetadata'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = package['name']
  s.version = package['version']
  s.summary = package['description']
  s.homepage = 'https://github.com/bitcomputing/imsdk-rn'
  s.license = 'Apache-2.0'
  s.authors = { 'Juggle IM' => 'support@juggleim.com' }
  s.platforms = { :ios => '12.0' }
  s.source = { :git => 'https://github.com/bitcomputing/imsdk-rn.git', :branch => 'main' }
  s.source_files = 'juggleim-rnsdk/ios/**/*.{h,m,mm}'
  s.requires_arc = true
  s.dependency 'React-Core'
  s.dependency 'JuggleIM', NativeSDKMetadata.version('JuggleIM')
  s.dependency 'JZegoCall', NativeSDKMetadata.version('JZegoCall')
end
