//
//  TimezoneList.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import SwiftUI

struct TimezoneList: View {
    var timezones: [String] {
        TimeZone.knownTimeZoneIdentifiers
            .map { TimeZone(identifier: $0) }
            .compactMap{ $0 }
            .map { timeZone -> String in
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.dateFormat = "VVV"
                formatter.timeZone = timeZone
                formatter.locale = Locale(identifier: "pt")
                return "(\(timeZone.abbreviation() ?? "")) \(formatter.string(from: Date()))"
            }
    }
    
    var body: some View {
        List(timezones, id: \.self) { timezone in
            Text(timezone)
        }
    }
}

struct TimezoneList_Previews: PreviewProvider {
    static var previews: some View {
        TimezoneList()
    }
}
