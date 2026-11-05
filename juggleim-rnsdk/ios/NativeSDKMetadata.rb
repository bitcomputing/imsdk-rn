require 'pathname'
require 'xcodeproj'

module NativeSDKMetadata
  ROOT = Pathname.new(__dir__).parent.realpath unless const_defined?(:ROOT, false)
  SOURCE = ROOT.join('native/imsdk-ios') unless const_defined?(:SOURCE, false)

  def self.version(name)
    spec = SOURCE.join(name, "#{name}.podspec")
    match = File.read(spec).match(/^\s*s\.version\s*=\s*['\"]([^'\"]+)['\"]/)
    raise "Cannot read #{name} version from #{spec}" unless match
    match[1]
  end

  def self.commit
    commit = IO.popen(['git', '-C', SOURCE.to_s, 'rev-parse', 'HEAD'], &:read).strip
    raise 'Cannot read iOS SDK Git commit' if commit.empty?
    commit
  end

  def self.public_headers
    project = Xcodeproj::Project.open(SOURCE.join('JuggleIM/JuggleIM.xcodeproj').to_s)
    target = project.targets.find { |item| item.name == 'JuggleIM' }
    raise 'Missing JuggleIM Xcode target' unless target
    headers = target.headers_build_phase.files.select do |file|
      (file.settings || {}).fetch('ATTRIBUTES', []).include?('Public')
    end.map { |file| file.file_ref.real_path.relative_path_from(ROOT).to_s }
    raise 'No public JuggleIM headers found' if headers.empty?
    headers.sort
  end
end
