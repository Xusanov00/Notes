//
//  Ex+UIColor.swift
//  Notes
//
//  Created by Ali on 02/05/23.
//

import UIKit

extension UIColor {
    static func appColor(color: Colors) -> UIColor {
        var withcolor = UIColor.white
        switch color {
        case .mainBack: withcolor = UIColor(named: "mainBack")!
        case .noteCreatorBack: withcolor = UIColor(named: "noteCreatorBack")!
            
        case .calendarBack: withcolor = UIColor(named: "calendarBack")!
        case .calendarWeekdays: withcolor = UIColor(named: "calendarWeekdays")!
        case .calendarYears: withcolor = UIColor(named: "calendarYears")!
            
        case .noteRed: withcolor = UIColor(named: "noteRed")!
        case .noteGreen: withcolor = UIColor(named: "noteGreen")!
        case .noteBlue: withcolor = UIColor(named: "noteBlue")!
            
        case .titleLbl: withcolor = UIColor(named: "titleLbl")!
        case .subtitleLbl: withcolor = UIColor(named: "subtitleLbl")!
        case .dateLbl: withcolor = UIColor(named: "dateLbl")!
            
        }
        return withcolor
    }
}

enum Colors {
    case mainBack
    case noteBlue
    case noteRed
    case noteGreen
    case calendarBack
    case calendarWeekdays
    case calendarYears
    case titleLbl
    case subtitleLbl
    case dateLbl
    case noteCreatorBack
}





