//
//  VelentiumDatepicker.swift
//  VelentiumDatepicker
//
//  Created by Hugo Aguero on 4/27/17.
//  Copyright © 2017 Velentium. All rights reserved.
//

import UIKit

 @IBDesignable public class VelentiumDatepicker: UIView , DateViewControllerDelegate , PredefinedRangesViewControllerDelegate {
    
    //MARK:Views
    @IBOutlet var view: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var generalView: UIControl!
    
    //MARK:Labels
    @IBOutlet var dateRangeLabel: UILabel!
    
    //MARK: Buttons
    @IBOutlet var predefinedRangesControl: UIControl!
    
    //MARK: UIImageView
    
    @IBOutlet var calendarImageView: UIImageView!
    @IBOutlet var dateRangeImageView: UIImageView!
    
    
    //MARK:Public Vars
    public var initialDate : Date! = nil
    public var finalDate : Date! = nil
    public var parentViewController : UIViewController!
    
    //MARK: IBInspectable
    @IBInspectable public var isSingleSelectionDate : Bool = false
    
    @IBInspectable public var datePickerBackgroundColor : UIColor = UIColor.lightGray {
        didSet {
            colorSetUp()
        }
    }
    
    @IBInspectable public  var labelColor : UIColor = UIColor.white {
        didSet {
            colorSetUp()
        }
    }
    
    @IBInspectable public var predefinedRangesTitleColor : UIColor = UIColor.white
    @IBInspectable public var predefinedRangesRangeColor : UIColor = UIColor.white
    @IBInspectable public var showPredefinedRangesButton : Bool = true {
        didSet {
            viewSetup()
        }
    }
    
    @IBInspectable public var selectionColor : UIColor = UIColor.black
    @IBInspectable public var dayLabelTextColor : UIColor = UIColor.white
    @IBInspectable public var nonMonthDayLabelTextColor : UIColor = UIColor.lightGray
    @IBInspectable public var monthLabelTextColor : UIColor = UIColor.white
    @IBInspectable public var weekDayTextColor : UIColor = UIColor.white
    @IBInspectable public var cornerRadius : CGFloat = 5.0 {
        didSet {
            cornerRadiusSetup()
        }
    }
    
    @IBInspectable public var calendarIconImage : UIImage  {
        didSet {
            imagesSetup()
        }
    }
    
    @IBInspectable public var predefinedDateRangeIconImage : UIImage  {
        didSet {
            imagesSetup()
        }
    }
    
    @IBInspectable public var labelFont : UIFont  {
        didSet {
            fontSetup()
        }
    }
    
    @IBInspectable public var dateFormat : String = ""
    
    fileprivate let longDateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()
    
    fileprivate let monthformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()

    func getCalendarDefaultImage()->UIImage{
        if let defaultImage = UIImage(named: "calendar"){
            return defaultImage
        }else{
            return UIImage()
        }
    }
    
    func initViews () {
        xibSetup()
        colorSetUp()
        viewSetup ()
        cornerRadiusSetup()
        imagesSetup()
        fontSetup()
    }
    
    func fontSetup () {
        dateRangeLabel.font = labelFont
    }
    
    func cornerRadiusSetup () {
        self.layer.cornerRadius = cornerRadius
    }
    
    func colorSetUp(){
        generalView.backgroundColor = datePickerBackgroundColor
        dateRangeLabel.textColor = labelColor
    }
    
    func imagesSetup () {
        calendarImageView.image = calendarIconImage
        dateRangeImageView.image = predefinedDateRangeIconImage
    }
    
    func viewSetup () {
        clipsToBounds = true
        predefinedRangesControl.isHidden = isSingleSelectionDate
        if (!isSingleSelectionDate) {
            predefinedRangesControl.isHidden = !showPredefinedRangesButton
        }
        dateRangeLabel.text =  buildText(initialDate: initialDate, finalDate: finalDate)
    }
    
    override init(frame: CGRect) {
        let calendarImage: UIImage = UIImage (named: "calendarDefault", in: Bundle(for: DateViewController.self), compatibleWith: nil)!
        calendarIconImage = calendarImage
        let predefinedDateRangeImage: UIImage = UIImage (named: "predefinedDateRangeDefault", in: Bundle(for: DateViewController.self), compatibleWith: nil)!
        predefinedDateRangeIconImage = predefinedDateRangeImage
        labelFont = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        super.init(frame: frame)
        parentViewController = nil
        initViews()
    }
    
    public required init(coder aDecoder: NSCoder) {
        let calendarImage: UIImage = UIImage (named: "calendarDefault", in: Bundle(for: DateViewController.self), compatibleWith: nil)!
        calendarIconImage = calendarImage
        let predefinedDateRangeImage: UIImage = UIImage (named: "predefinedDateRangeDefault", in: Bundle(for: DateViewController.self), compatibleWith: nil)!
        predefinedDateRangeIconImage = predefinedDateRangeImage
        labelFont = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        super.init(coder: aDecoder)!
        parentViewController = nil
        initViews()
    }
    
    func xibSetup (){
        view = UINib(nibName: "VelentiumDatepicker", bundle: Bundle(for:type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    //MARK:Touch Events
    @IBAction func predefinedRangesUIControlTouched(_ sender: Any) {
        openPredefinedRangesViewController()
    }
    
    @IBAction func controlTouched(_ sender: Any) {
        openCalendarViewController()
    }
    
    func openPredefinedRangesViewController () {
        print ("Predefined ranges touched")
        let storyBoard = UIStoryboard(name: "MainDatePicker", bundle: Bundle(for: DateViewController.self))
        let predefinedRangesViewController = storyBoard.instantiateViewController(withIdentifier: "PredefinedRangesViewController") as! PredefinedRangesViewController
        predefinedRangesViewController.delegate = self
        predefinedRangesViewController.predefinedRangeBackgroundColor = self.datePickerBackgroundColor
        predefinedRangesViewController.predefinedRangesTitleColor  = self.predefinedRangesTitleColor
        predefinedRangesViewController.predefinedRangesRangeColor = self.predefinedRangesRangeColor
        if (parentViewController == nil ) {
            fatalError("No parent controller detected, please assign a parent to make sure the datepicker popover will appear, Example: datepicker.parentViewController = self")
        }else {
            parentViewController.present(predefinedRangesViewController, animated: true, completion: nil)
        }
    }
    
    
    func openCalendarViewController (){
        let storyBoard = UIStoryboard(name: "MainDatePicker", bundle: Bundle(for: DateViewController.self))
        let dateViewController = storyBoard.instantiateViewController(withIdentifier: "DateViewController") as! DateViewController
        dateViewController.delegate = self
        dateViewController.isSingleDateSelection = isSingleSelectionDate
        dateViewController.datePickerBackgroundColor = self.datePickerBackgroundColor;
        dateViewController.selectionColor = self.selectionColor
        dateViewController.dayLabelTextColor = self.dayLabelTextColor
        dateViewController.nonMonthDayLabelTextColor = self.nonMonthDayLabelTextColor
        dateViewController.monthLabelTextColor = self.monthLabelTextColor
        dateViewController.weekdayTextColor = self.weekDayTextColor
        if (initialDate != nil) {
            dateViewController.initialDate = initialDate
        }
        if (finalDate != nil) {
            dateViewController.finalDate = finalDate
        }
        if (parentViewController == nil ) {
             fatalError("No parent controller detected, please assign a parent to make sure the datepicker popover will appear, Example: datepicker.parentViewController = self")
        }else {
            parentViewController.present(dateViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: DateViewControllerDelegate
    func userDidSavedDates(initialDate: Date?, finalDate: Date?) {
        assignValues(initialDate: initialDate, finalDate: finalDate)
    }
    
    //MARK: PredefinedRangesViewControllerDelegate
    func userDidSelectedPredefinedRangeWithDates(initialDate: Date, finalDate: Date) {
        assignValues(initialDate: initialDate, finalDate: finalDate)
    }
    
    func assignValues (initialDate: Date? , finalDate: Date?) {
        print ("User selected \(String(describing: initialDate)) and \(String(describing: finalDate))")
        self.initialDate = initialDate
        self.finalDate = finalDate
        dateRangeLabel.text = buildText(initialDate: initialDate, finalDate: finalDate)
    }
    
    /// <#Description#>
    ///  Builds the text to show on the label when the selected dates have changed
    ///
    /// - Parameters:
    ///   - initialDate: Initial Date selected by the user
    ///   - finalDate: Final date selected by the user
    /// - Returns: a custom string showing the date ranges
    func buildText (initialDate: Date! , finalDate: Date!)-> String {
        var dateString = ""
        if initialDate == nil && finalDate == nil {
            dateString = "Anytime"
        }else if isSingleSelectionDate {
            dateString =  dateFormat == "" ?  self.longDateformatter.string(from: initialDate!) : getSingleRangeTextWithFormat(initialDate: initialDate!)
        }else {
            dateString =  buildRangeText(initialDate: initialDate!, finalDate: finalDate!)
        }
        return dateString
    }
    
    func buildRangeText (initialDate: Date , finalDate: Date)-> String {
        let currentYear = Date().getYear()
        var dateString = ""
        let datesAreOntheCurrentYear = initialDate.getYear() == currentYear &&
                                       finalDate.getYear() == currentYear
        let datesAreOnTheSameYearAndSameMonthAndSameDay = initialDate.getYear() == finalDate.getYear() &&
                                                          initialDate.getMonth() == finalDate.getMonth() &&
                                                          initialDate.getDay() == finalDate.getDay()
        let datesAreOnTheSameYearAndSameMonth = initialDate.getYear() == finalDate.getYear() &&
            initialDate.getMonth() == finalDate.getMonth()
        let datesAreOnTheSameYear = initialDate.getYear() == finalDate.getYear()
        if (dateFormat != "") {
            dateString = getRangeTextWithFormat(initialDate: initialDate, finalDate: finalDate)
        }else {
            dateString = getRangeText(datesAreOnTheSameYearAndSameMonthAndSameDay: datesAreOnTheSameYearAndSameMonthAndSameDay,
                                      datesAreOnTheSameYearAndSameMonth: datesAreOnTheSameYearAndSameMonth,
                                      datesAreOnTheSameYear: datesAreOnTheSameYear,
                                      datesAreOntheCurrentYear: datesAreOntheCurrentYear,
                                      initialDate: initialDate,
                                      finalDate: finalDate)
        }
        return dateString
    }
    
    func getSingleRangeTextWithFormat (initialDate: Date )->String {
        return "\(initialDate.getDateStringWithFormat(format: dateFormat))"
    }

    func getRangeTextWithFormat (initialDate: Date , finalDate: Date )->String {
        return "\(initialDate.getDateStringWithFormat(format: dateFormat))-\(finalDate.getDateStringWithFormat(format: dateFormat))"
    }
    
    func getRangeText (datesAreOnTheSameYearAndSameMonthAndSameDay: Bool , datesAreOnTheSameYearAndSameMonth: Bool, datesAreOnTheSameYear: Bool , datesAreOntheCurrentYear: Bool , initialDate: Date , finalDate: Date  )->String{
        var dateString = ""
        if datesAreOnTheSameYearAndSameMonthAndSameDay {//Same dates
            dateString = "\(initialDate.getDay()) \(initialDate.getMonthName())"
        } else if datesAreOnTheSameYearAndSameMonth { //Same month and year
            dateString = "\(initialDate.getMonthName()) \(initialDate.getDay())-\(finalDate.getDay()) "
        }else if datesAreOnTheSameYear { //Same Year
            dateString = "\(initialDate.getDay()) \(initialDate.getMonthName())-\(finalDate.getDay()) \(finalDate.getMonthName())"
        }else {
            if (dateFormat != "") {
                 dateString = "\(initialDate.getLongFormat())-\(finalDate.getLongFormat())"
            }else {
                dateString = getRangeTextWithFormat(initialDate: initialDate, finalDate: finalDate)
            }
        }
        if datesAreOnTheSameYearAndSameMonthAndSameDay || datesAreOnTheSameYearAndSameMonth || datesAreOnTheSameYear {
            if !datesAreOntheCurrentYear {
                dateString = "\(dateString) \(initialDate.getYear())"
            }
        }
        return dateString
    }
}
