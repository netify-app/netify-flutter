Pod::Spec.new do |s|
  s.name             = 'netify'
  s.version          = '2.0.0'
  s.summary          = 'A lightweight network inspector for Flutter apps using Dio.'
  s.description      = <<-DESC
A lightweight, debug-only network inspector for Flutter apps using Dio HTTP client.
                       DESC
  s.homepage         = 'https://github.com/ricoerlan/netify'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rico Erlan' => 'ricoerlan@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
