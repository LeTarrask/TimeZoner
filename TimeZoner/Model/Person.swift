//
//  Person.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import SwiftUI

struct Person: Identifiable {
    public let id: UUID = UUID()
    var name: String
    var timezone: TimeZone
    var color: Color
    var image: Image?
    
    let formatter = DateFormatter()

    func localHour() -> Int {
        formatter.timeZone = timezone
        formatter.dateFormat = "HH"
        return Int(formatter.string(from: Date())) ?? 0
    }
    
    func localMinute() -> Int {
        formatter.timeZone = timezone
        formatter.dateFormat = "mm"
        return Int(formatter.string(from: Date())) ?? 0
    }
}



