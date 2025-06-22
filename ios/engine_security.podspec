Pod::Spec.new do |s|
  s.name             = 'engine_security'
  s.version          = '1.1.0'
  s.summary          = 'Advanced security detection system for Flutter applications'
  s.description      = <<-DESC
Advanced security detection system for Flutter applications focused on Android and iOS. 
Detects Frida, Root/Jailbreak, Emulator, Debugger, and GPS Fake threats with high precision.
                       DESC
  s.homepage         = 'https://github.com/moreirawebmaster/engine-security'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'moreirawebmaster' => 'moreirawebmaster@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end 