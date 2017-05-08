//
//  PredefinedRangesViewController.swift
//  VelentiumDatepicker
//
//  Created by Hugo Aguero on 4/29/17.
//  Copyright © 2017 Velentium. All rights reserved.
//

import UIKit

protocol PredefinedRangesViewControllerDelegate  {
    func userDidSelectedPredefinedRangeWithDates(initialDate:Date , finalDate: Date )
}


class PredefinedRangesViewController: UIViewController, UITableViewDataSource , UITableViewDelegate{
    var delegate: PredefinedRangesViewControllerDelegate?
    let dateRangeIdentifier = "DateRangeTableViewCell"
    var dateRanges = [dateRange]()
    struct dateRange {
        var title = ""
        var rangeString = ""
        var initialDate : Date = Date ()
        var finalDate: Date =  Date ()
    }
    public var  predefinedRangeBackgroundColor = UIColor.lightGray
    @IBOutlet var mainView: UIView!
    public var predefinedRangesTitleColor : UIColor = UIColor.white
    public var predefinedRangesRangeColor : UIColor = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        buildDataSource()
    }
    
    func initViews () {
        mainView.backgroundColor = self.predefinedRangeBackgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildDataSource () {
       dateRanges.append(build30DaysRange())
       dateRanges.append(buildThisMonthRange())
       dateRanges.append(buildLastMonthRange())
       dateRanges.append(buildLastMonths(monthAmount: 3))
       dateRanges.append(buildLastMonths(monthAmount: 6))
       dateRanges.append(buildLastYear())
       //dateRanges.append(buildAllTime()) // This gives performance problems is better to use anytime logic.  Ask the client about this
    }
    
    func build30DaysRange ()->dateRange {
        let finalDate = Date().start()
        let initialDate = finalDate.addDays(numberOfDays: -29)
        return dateRange(title: "Last 30 days", rangeString: getRangeString(initialDate: initialDate, finalDate: finalDate), initialDate: initialDate, finalDate: finalDate)
    }
    
    func buildThisMonthRange ()->dateRange {
        let initialDate = Date().startOfMonth()
        let finalDate = Date().start()
        return dateRange(title: "This month", rangeString: getRangeString(initialDate: initialDate, finalDate: finalDate), initialDate: initialDate, finalDate: finalDate)
    }
    
    func buildLastMonthRange ()->dateRange {
        let initialDate = Date().addMonths(numberOfMonths: -1).startOfMonth()
        let finalDate = Date().addMonths(numberOfMonths: -1).endOfMonth()
        return dateRange(title: "Last month", rangeString: getRangeString(initialDate: initialDate, finalDate: finalDate), initialDate: initialDate, finalDate: finalDate)
    }
    
    func buildLastMonths (monthAmount: Int) ->dateRange {
        let finalDate = Date().addMonths(numberOfMonths: -1).endOfMonth()
        let initialDate = Date().endOfMonth().addMonths(numberOfMonths: -monthAmount).startOfMonth()
        return dateRange(title: "Last \(monthAmount) months", rangeString: getRangeString(initialDate: initialDate, finalDate: finalDate), initialDate: initialDate, finalDate: finalDate)
    }
    
    func buildLastYear () ->dateRange{
        let initialDate = Date().addYears(numberOfYears: -1).startOfYear()
        let finalDate = Date().addYears(numberOfYears: -1).endOfYear()
        return dateRange (title: "Last year", rangeString: getRangeString(initialDate: initialDate, finalDate: finalDate), initialDate: initialDate, finalDate: finalDate)
    }
    
    func buildAllTime ()->dateRange {
        var dateComponents = DateComponents ()
        dateComponents.year = 2000
        dateComponents.month = 1
        dateComponents.day = 1
        let initialDate = Calendar.current.date(from: dateComponents)
        let finalDate = Date().start()
        return dateRange(title: "All time", rangeString: getRangeString(initialDate: initialDate!, finalDate: finalDate), initialDate: initialDate!, finalDate: finalDate)
    }
    
    
    func getRangeString (initialDate: Date, finalDate: Date)->String {
        return "\(initialDate.getLongFormat())-\(finalDate.getLongFormat())"
    }
    
    
    @IBAction func closeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:UITableViewDatasourceDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateRanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DateRangeTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: dateRangeIdentifier) as! DateRangeTableViewCell)
        let dateRange : dateRange = dateRanges[indexPath.row]
        cell?.dateRangeHeaderLabel.text = dateRange.title
        cell?.dateRangeLabel.text = dateRange.rangeString
        cell?.dateRangeHeaderLabel.textColor = predefinedRangesTitleColor
        cell?.dateRangeLabel.textColor = predefinedRangesRangeColor
        cell?.selectionStyle = .none
        return cell!;
    }
    
    //MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateRange: dateRange = dateRanges[indexPath.row]
        delegate?.userDidSelectedPredefinedRangeWithDates(initialDate: dateRange.initialDate, finalDate: dateRange.finalDate)
        dismiss(animated: true, completion: nil)
    }
    
}
