//
//  Person.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import SwiftUI

struct Person: Identifiable, Codable {
    public var id: UUID = UUID()
    var name: String
    var timezone: TimeZone
    var color: Color
    var imagePath: String?

    
    func localHour() -> Int {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "HH"
        return Int(formatter.string(from: Date())) ?? 0
    }
    
    func localMinute() -> Int {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "mm"
        return Int(formatter.string(from: Date())) ?? 0
    }
}



