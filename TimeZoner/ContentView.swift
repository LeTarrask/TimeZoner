//
//  ContentView.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let manager = TimeManager()
        let testPersons: [Person] = [
            Person(name: "SambaRock", timezone: TimeZone(identifier: "America/New_York") ?? TimeZone(identifier: "GMT")!),
            Person(name: "Cotey", timezone: TimeZone(identifier: "America/Chicago") ?? TimeZone(identifier: "GMT")!),
            Person(name: "Mikee", timezone: TimeZone(identifier: "America/Los_Angeles") ?? TimeZone(identifier: "GMT")!)
        ]
        
        manager.persons = testPersons
        
        return Watch(manager: manager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
