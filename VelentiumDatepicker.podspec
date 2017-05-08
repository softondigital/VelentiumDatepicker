
Pod::Spec.new do |s|
  s.name         = "VelentiumDatepicker"
  s.version      = "1.0.0"
  s.summary      = "Custom datepicker component"
  s.description  = "Custom datepicker with calendar popover and predefined ranges to choose from"
  s.homepage     = "http://velentium.com"
  s.license      = "MIT"
  s.author       = { "Hugo Aguero" => "hugo.aguero@softonitg.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/softondigital/VelentiumDatepicker.git", :tag => "1.0.0" }
  s.source_files  = "VelentiumDatepicker", "VelentiumDatepicker/**/*.{h,m,swift}"
  s.resources    = "VelentiumDatepicker/*.{xcassets,xib,storyboard}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
  s.dependency 'FSCalendar'
end
