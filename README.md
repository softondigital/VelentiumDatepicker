# VelentiumDatepicker
A component to choose date ranges on IOS

#Installation 
1. Install cocoa pods. You can have some guidance on https://guides.cocoapods.org/using/getting-started.html.
```
$ sudo gem install cocoapods
```
2. Open the project folder on terminal
```
$ cd <YourXcodeProjectFolder>
```
3. Init the pod.
```
$ pod init
```
4. This will generate a fille called PodFile.  Open this file on a text editor.
5. On the desired target add the following text: 
```
pod 'VelentiumDatepicker', :git => 'https://github.com/softondigital/VelentiumDatepicker.git', :tag => '1.0.1'
```
If you want to use a specific version just change the tag number.
6. At the end of the pod put this text.
```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end
```

This is a workaround for a known issue with IBInspectable  properties.  This text will let you change the datepicker properties using interface builder and also see how it looks on the interface editor.  This is just a workaround and not a definitive solutions so please read https://github.com/CocoaPods/CocoaPods/issues/5334 in case you're facing issues using the component.

7. So far this is how the podfile should look with a target called  'DatePickerPodTest'
```

target 'DatePickerPodTest' do
  use_frameworks!
  pod 'VelentiumDatepicker', :git => 'https://github.com/softondigital/VelentiumDatepicker.git', :tag => '1.0.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end

```





