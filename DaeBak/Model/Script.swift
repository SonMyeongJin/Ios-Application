//
//  Script.swift
//  DaeBak
//
//  Created by 손명진 on 1/15/25.
//

import Foundation
import SwiftData

@Model
class Script{
    var title: String
    var script_KOR: String = "null"
    var script_JPN: String = "null"
    
    init(title: String) {
        self.title = title
    }
}
