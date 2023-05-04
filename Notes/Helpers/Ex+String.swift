//
//  Ex+String.swift
//  Notes
//
//  Created by Ali on 01/05/23.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "dd.MM.yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}
