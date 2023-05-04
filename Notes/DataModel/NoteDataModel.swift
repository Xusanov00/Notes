//
//  NoteDataModel.swift
//  Notes
//
//  Created by Ali on 19/04/23.
//

import Foundation
import UIKit

struct NoteDataModel {
    var id: Int64?
    var title: String
    var subTitle: String
    var color: String
    var date: String
    
}



enum noteType: String {
    case all
    case noteRed
    case noteGreen
    case noteBlue
}

