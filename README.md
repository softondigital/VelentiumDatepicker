# VelentiumDatepicker
A component to choose date ranges on IOS

# Installation 

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

8. Install the cocoa pods by using
```
pod install
``` 

9.  This will generate a .xcworkspace file.  Always open the project with this file from this point.

# How to use it
1. Grab an UIView to the desired place
2. On the identity IBInspector put VelentiumDatepicker on the class field.

The component  have plenty of properties that can be stated on Interface builder. 
IsSingleSelectionDate : Bool (Stablish if the user can select a range or just a single date )
DatePickerBackgroundColor: UIColor (Background color of the component and the popovers)
LabelColor:UIColor (Text color of the label)
PredefinedRangesTitleColor: UIColor (Text color of the title on the predefined ranges popover)
PredefinedRangesRangeColor: UIColor (Text color of the range label on the predefined ranges popover)
ShowPredefinedRangesButton:  UIColor (Hides or unhides the predefined ranges button on the right side)
SelectionColor: UIColor (Color of the dates selected by the user)
DayLabelTextColor: UIColor (Color of the days of the month)
NonMonthDayLabelTextColor: UIColor (Color of the days that don't belong to the current displayed month)
WeekDayTextColor: UIColor (Color of the day names labels )
Corner Radius : CGFloat (Stablish how round the corners of the view should see )
CalendarIconImage : UIImage (Image that will be displayed on the left, leave empty for the default one)
PredefinedDateRangeIconImage: UIImage (Image that will be displayed on the right, leave empty for the default one)
DateFormat: String (The format to show the dates)

The same properties can be used on runtime, just use the first letter of the property as lowercase.

# How to know the selected dates 

Use the initialDate and finalDate properties.
```
print (\(datepicker.initialDate)-\(datepicker.finalDate)
```




