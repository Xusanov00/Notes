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
        
        var color: [UIColor] = []
        
        for note in DatabaseManager.shared.getNotes() {
            if date == note.date.toDate()! {
                switch note.color {
                case "noteRed": color.append(.red)
                case "noteGreen": color.append(.green)
                case "noteBlue": color.append(.blue)
                default: color.append(.clear)
                }
            }
            
            
        }
        // возвращаем цвет точки для этой даты
        return Array(Set(color))
    }
    
    
    //it needs to give dates to put point to them
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var color: [UIColor] = []
        
        for note in DatabaseManager.shared.getNotes() {
            if date == note.date.toDate()! {
                switch note.color {
                case "noteRed": color.append(.red)
                case "noteGreen": color.append(.green)
                case "noteBlue": color.append(.blue)
                default: color.append(.clear)
                }
            }
            
            
        }
        // возвращаем цвет точки для этой даты
        return Array(Set(color)).count
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        UISelectionFeedbackGenerator().selectionChanged()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        selectedCalendarDate = formatter.string(from: date)
        
        tablView.reloadData()
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .white
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        var color: [UIColor] = []
        
        for note in DatabaseManager.shared.getNotes() {
            if date == note.date.toDate()! {
                switch note.color {
                case "noteRed": color.append(.red)
                case "noteGreen": color.append(.green)
                case "noteBlue": color.append(.blue)
                default: color.append(.clear)
                }
            }
            
            
        }
        
        return Array(Set(color))
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//
//            appearance.borderSelectionColor = UIColor.red // цвет бордера для дат с event points
////            return nil // чтобы не заливать фон цветом выделения
////            appearance.backgroundColors = UIColor.clear
//
//        return appearance.selectionColor // стандартный цвет выделения для остальных дат
//    }
//
////    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, selectionColorFor date: Date) -> UIColor? {
////
////    }
}

