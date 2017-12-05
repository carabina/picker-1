Pod::Spec.new do |s|
  s.name             = 'ios-phone-picker'
  s.version          = '0.1.0'
  s.summary          = 'Picker for phone number. Includes country code picker.'

  s.description      = 'This is a picker for phone number. Includes country code picker. Awesome.'
 
  s.homepage         = 'https://github.com/manuelvrhovac/number-picker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Manuel Vrhovac' => 'manuel.vrhovac@me.com' }
  s.source           = { :git => 'https://github.com/manuelvrhovac/number-picker', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = '/Users/Manuel/Dropbox/0 Development 2018/ios-phone-picker/*'
 
end