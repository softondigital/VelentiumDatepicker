
Pod::Spec.new do |s|
  s.name         = "VelentiumDatepicker"
  s.version      = "0.0.1"
  s.summary      = "Custom datepicker component"
  s.description  = "Custom datepicker with calendar popover and predefined ranges to choose from"
  s.homepage     = "http://velentium.com"
  s.license      = "MIT"
  s.author       = { "Hugo Aguero" => "hugo.aguero@softonitg.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :path => '.' }
  s.source_files  = "VelentiumDatepicker", "VelentiumDatepicker/**/*.{h,m,swift}"
  s.resources    = "VelentiumDatepicker/*.{xcassets,xib,storyboard}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
  s.dependency 'FSCalendar'
end
