//
//  DateViewController.swift
//  VelentiumDatepicker
//
//  Created by Hugo Aguero on 4/27/17.
//  Copyright © 2017 Velentium. All rights reserved.
//

import UIKit
import Foundation
import FSCalendar

protocol DateViewControllerDelegate  {
    func userDidSavedDates(initialDate:Date? , finalDate: Date? )
}

class DateViewController: UIViewController , FSCalendarDelegate , FSCalendarDataSource {
    var delegate : DateViewControllerDelegate?
    @IBOutlet var calendar: FSCalendar!
    var isInitialDateSelection = true
    public var isSingleDateSelection = false
    public var initialDate : Date?  = nil
    public var finalDate : Date? = nil
    public var datePickerBackgroundColor : UIColor = UIColor.lightGray
    public var selectionColor : UIColor = UIColor.black
    public var dayLabelTextColor : UIColor = UIColor.white
    public var nonMonthDayLabelTextColor: UIColor = UIColor.lightGray
    public var monthLabelTextColor : UIColor = UIColor.white
    public var weekdayTextColor : UIColor = UIColor.white
    
    //MARK: Views
    @IBOutlet var mainView: UIView!
    
    //MARK: LABELS
    @IBOutlet var startDateDayNameLabel: UILabel!
    @IBOutlet var startDateMonthAndDayLabel: UILabel!
    @IBOutlet var finalDateDayNameLabel: UILabel!
    @IBOutlet var finalDateMonthAndDayLabel: UILabel!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    //MARK: Formatters
    fileprivate let yearMonthDayformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let dayNameformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE,"
        return formatter
    }()
   
    fileprivate let monthNameAndDayformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (initialDate != nil) {
            calendar.setCurrentPage(initialDate!, animated: true)
        }
        
    }
    
    func initViews (){
        //Set default dates and selections
        if (isSingleDateSelection) {
             if  let initialDate = initialDate {
                calendar.select(initialDate)
                setDateAndFillLabels(date: initialDate)
                calendar.setCurrentPage(initialDate, animated: false)
            }
        }else {
            if  let initialDate = initialDate {
                calendar.select(initialDate)
                setDateAndFillLabels(date: initialDate)
                calendar.setCurrentPage(initialDate, animated: false)
            }
            
            if let finalDate = finalDate {
                calendar.select(finalDate)
                setDateAndFillLabels(date: finalDate)
            }
        }
        mainView.backgroundColor = self.datePickerBackgroundColor
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.appearance.titleDefaultColor = dayLabelTextColor
        calendar.appearance.titlePlaceholderColor = nonMonthDayLabelTextColor
        calendar.appearance.headerTitleColor = monthLabelTextColor
        calendar.appearance.weekdayTextColor = weekdayTextColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Touch events
    @IBAction func closeButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearControlTouched(_ sender: Any) {
        clearInitialDate()
        clearFinalDate()
        isInitialDateSelection = true
        removeSelectedDates()
        configureVisibleCells()
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        if  finalDate != nil && finalDate! < initialDate!{
            showAlert(message: "The final date should not be before the initial date")
            return
        }
        if (initialDate != nil && finalDate == nil) {
            finalDate = initialDate
        }
        //trigger save dates function delegate
        delegate?.userDidSavedDates(initialDate: initialDate, finalDate: finalDate)
        dismiss(animated: true, completion: nil)
    }
    
    func clearInitialDate () {
        initialDate = nil
        startDateDayNameLabel.text = "Start"
        startDateMonthAndDayLabel.text = "Date"
    }
    
    func clearFinalDate () {
        finalDate = nil
        finalDateDayNameLabel.text = "End"
        finalDateMonthAndDayLabel.text = "Date"
    }
    
    func removeSelectedDates () {
        for  date in calendar.selectedDates   {
            calendar.deselect(date)
        }
    }

    func showAlert (message: String) {
        let alert = UIAlertController (title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        setDateAndFillLabels(date: date)
        self.configureVisibleCells()
        print("did deselect date \(self.yearMonthDayformatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //Prevent deselect of a date
        calendar.select(date)
        self.configureVisibleCells()
    }
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        if (self.gregorian.isDateInToday(date)){
            print ("")
        }
        diyCell.selectionType = getSelectionType(date: date)
       
        // Configure selection layer
        if position == .current {
            let selectionType = getSelectionType(date: date)
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            diyCell.circleImageView.isHidden = true
            
        } else {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
    
    func getSelectionType (date:Date)->SelectionType {
        var selectionType = SelectionType.none
        if calendar.selectedDates.contains(date) {
            let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
            let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
            if calendar.selectedDates.contains(date) {
                if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                    selectionType = .middle
                }
                else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                    selectionType = .rightBorder
                }
                else if calendar.selectedDates.contains(nextDate) {
                    selectionType = .leftBorder
                }
                else {
                    selectionType = .single
                }
            }
        }
        else {
            selectionType = .none
        }
        return selectionType
    }
    
    func setDateAndFillLabels (date: Date ) {
        if (isSingleDateSelection) {
            setDateAndFillLabelsForSingleSelection(date: date )
        }else {
            setDateAndFillLabelsForDateRange (date: date)
        }
        clearDatesForSingleSelection()
        selectDateRange()
    }
    
    //ads all the dates on the range to show the range visually on the calendar
    func selectDateRange () {
        if !isSingleDateSelection && initialDate != nil && finalDate != nil {
            removeSelectedDates()
            var currentDate = initialDate
            repeat {
                calendar.select(currentDate)
                currentDate = currentDate?.addDays(numberOfDays: 1)
            }while currentDate! <= finalDate!
        }
    }
    
    func setDateAndFillLabelsForSingleSelection (date:Date) {
        initialDate = date
        finalDate = date
        startDateDayNameLabel.text = self.dayNameformatter.string(from: date)
        startDateMonthAndDayLabel.text  = self.monthNameAndDayformatter.string(from: date)
        finalDateDayNameLabel.text  = self.dayNameformatter.string(from: date)
        finalDateMonthAndDayLabel.text = self.monthNameAndDayformatter.string(from: date)
    }
    
    
    func setDateAndFillLabelsForDateRange (date:Date ){
        var addDateAtFinish = false
        if !isInitialDateSelection && date < initialDate! {
            print ("Date is less than initial one, resetting...")
            removeSelectedDates()
            clearControlTouched((Any).self)
            isInitialDateSelection = true
            addDateAtFinish = true
        }
        if (isInitialDateSelection) {
            initialDate = date
            startDateDayNameLabel.text = self.dayNameformatter.string(from: date)
            startDateMonthAndDayLabel.text  = self.monthNameAndDayformatter.string(from: date)
            isInitialDateSelection = false
        }else {
            finalDate = date
            finalDateDayNameLabel.text  = self.dayNameformatter.string(from: date)
            finalDateMonthAndDayLabel.text = self.monthNameAndDayformatter.string(from: date)
            isInitialDateSelection = true
        }
        clearDatesForSingleSelection()
        if (addDateAtFinish) {
            calendar.select(initialDate)
        }
    }
    
    func clearDatesForSingleSelection () {
        let maxSelectedItems = 1
        if (isSingleDateSelection &&  calendar.selectedDates.count > maxSelectedItems) {
            let dateToRemove = calendar.selectedDates.first
            print("removing \(self.yearMonthDayformatter.string(from: dateToRemove!))")
            calendar.deselect(dateToRemove!)
        }
    }
}
