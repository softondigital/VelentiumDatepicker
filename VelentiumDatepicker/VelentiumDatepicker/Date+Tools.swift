//
//  Date+Tools.swift
//  VelentiumDatepicker
//
//  Created by Hugo Aguero on 4/29/17.
//  Copyright © 2017 Velentium. All rights reserved.
//

import UIKit

extension Date {
    
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfYear() -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear())!
    }
    
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func addDays (numberOfDays: Int)->Date {
        //It seems that adding dates don't consider the day itself, so -29 instead of -30
        return Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)!
    }
    
    func addMonths (numberOfMonths: Int)->Date {
        return Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)!
    }
    
    func addYears (numberOfYears: Int)->Date {
        return Calendar.current.date(byAdding: .year, value: numberOfYears, to: self)!
    }
    
    func start()->Date {
        let calendar = Calendar(identifier: .gregorian)
        let dateStart = calendar.startOfDay(for: self)
        return dateStart
    }
    
    func getLongFormat ()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        
        return  formatter.string(from: self)
    }
    
    func getDateStringWithFormat (format:String)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return  formatter.string(from: self)
    }
    
    func getMonthName ()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        return  formatter.string(from: self)
    }
    
    func getYear()->Int {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: self)
        return year
    }
    
    func getMonth()->Int {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.month, from: self)
        return year
    }
    
    func getDay()->Int {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.day, from: self)
        return year
    }
}
