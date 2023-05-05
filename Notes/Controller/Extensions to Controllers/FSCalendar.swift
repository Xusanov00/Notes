//
//  FSCalendar.swift
//  Notes
//
//  Created by Ali on 01/05/23.
//

import FSCalendar


//MARK: FSCalendarDelegate
extension MainViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    //to put event points in calendar dates:
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        eventColorArr = []
        
        for note in DatabaseManager.shared.getNotes() {
            if date == note.date.toDate()! {
                switch sortedType {
                case .all:
                    switch note.color {
                    case "noteRed": eventColorArr.append(.red)
                    case "noteGreen": eventColorArr.append(.green)
                    case "noteBlue": eventColorArr.append(.blue)
                    default: ""
                    }
                    
                case .noteRed:
                    switch note.color {
                    case "noteRed": eventColorArr.append(.red)
                    default: ""
                    }
                    
                case .noteGreen:
                    switch note.color {
                    case "noteGreen": eventColorArr.append(.green)
                    default: ""
                    }
                    
                case .noteBlue:
                    switch note.color {
                    case "noteBlue": eventColorArr.append(.blue)
                    default: ""
                    }
                }
                
            }
            
            
        }
        // возвращаем цвет точки для этой даты
        return Array(Set(eventColorArr))
    }
    
    
    //it needs to give dates to put point to them
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        eventColorArr = []
        
        for note in DatabaseManager.shared.getNotes() {
            if date == note.date.toDate()! {
                switch sortedType {
                case .all:
                    switch note.color {
                    case "noteRed": eventColorArr.append(.red)
                    case "noteGreen": eventColorArr.append(.green)
                    case "noteBlue": eventColorArr.append(.blue)
                    default: ""
                    }

                case .noteRed:
                    switch note.color {
                    case "noteRed": eventColorArr.append(.red)

                    default: ""
                    }

                case .noteGreen:
                    switch note.color {
                    case "noteGreen": eventColorArr.append(.green)
                    default: ""
                    }

                case .noteBlue:
                    switch note.color {
                    case "noteBlue": eventColorArr.append(.blue)
                    default: ""
                    }
                }

            }
        }
        // возвращаем цвет точки для этой даты
        return Array(Set(eventColorArr)).count
    }
    
    //MARK: Shows notes day by day
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        UISelectionFeedbackGenerator().selectionChanged()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        selectedCalendarDate = formatter.string(from: date)
        
        tablView.reloadData()
    }
    
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        
        eventColorArr = []
        
        for note in DatabaseManager.shared.getNotes() {
            if date == note.date.toDate()! {
                switch sortedType {
                case .all:
                    switch note.color {
                    case "noteRed": eventColorArr.append(.red)
                    case "noteGreen": eventColorArr.append(.green)
                    case "noteBlue": eventColorArr.append(.blue)
                    default: ""
                    }
                    
                case .noteRed:
                    switch note.color {
                    case "noteRed": eventColorArr.append(.red)
                    default: ""
                    }
                    
                case .noteGreen:
                    switch note.color {
                    case "noteGreen": eventColorArr.append(.green)
                    default: ""
                    }
                    
                case .noteBlue:
                    switch note.color {
                    case "noteBlue": eventColorArr.append(.blue)
                    default: ""
                    }
                }
                
            }
            
            
        }
        // возвращаем цвет точки для этой даты
        return Array(Set(eventColorArr))
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        .red
    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return nil
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
            return #colorLiteral(red: 0, green: 0.007745540235, blue: 0.787543118, alpha: 0.5)
        }else {
            return nil
        }
    }
}

