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
}



