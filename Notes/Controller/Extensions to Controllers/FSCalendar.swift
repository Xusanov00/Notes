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
                    case "noteGreen": eventColorArr.append(.blue)
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
                    case "noteGreen": eventColorArr.append(.blue)
                    default: ""
                    }
                }

            }
        }
        // возвращаем цвет точки для этой даты
        return Array(Set(eventColorArr)).count
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        .red
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        var color: UIColor?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        switch sortedType {// switches notes by color
        case .all:
            return nil
        case .noteRed:
            DatabaseManager.shared.getNotes().map { note in
                if note.date == dateFormatter.string(from: date) && note.color == "noteRed" {
                    color = .red
                }
            }
        case .noteGreen:
            DatabaseManager.shared.getNotes().map { note in
                if note.date == dateFormatter.string(from: date) && note.color == "noteGreen" {
                    color = .green
                }
            }
        case .noteBlue:
            DatabaseManager.shared.getNotes().map { note in
                if note.date == dateFormatter.string(from: date) && note.color == "noteBlue" {
                    color = .blue
                }
            }
        }
        print("color is", color)
        return color ?? nil
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

