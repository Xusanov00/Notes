//
//  CalendarVeiw.swift
//  Notes
//
//  Created by Ali on 20/04/23.
//

import Foundation
import FSCalendar

extension FSCalendar {

    func setEvent(_ date: Date, type: noteType) {
        switch type {
        case .all: self.appearance.eventSelectionColor = .clear
        case .noteRed: self.appearance.eventSelectionColor = .appColor(color: .noteRed)
        case .noteBlue: self.appearance.eventSelectionColor = .appColor(color: .noteBlue)
        case .noteGreen: self.appearance.eventSelectionColor = .appColor(color: .noteGreen)
        }
        self.select(date)
    }

}
