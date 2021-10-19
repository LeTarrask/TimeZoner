//
//  PersonsManagementView.swift
//  TimeZoner
//
//  Created by tarrask on 19/10/2021.
//

import SwiftUI

struct PersonsManagementView: View {
    @ObservedObject var manager: TimeManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.persons) { person in
                    HStack {
                        if (person.imagePath != nil) {
                            Image(person.imagePath!)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 30, height: 30, alignment: .center)
                        }
                        Text(person.name)
                        Spacer()
                        Text(person.timezone.identifier)
                    }
                }
                // TO DO: add call to manager delete person
            }
            .navigationTitle("Your current timezones")
            .navigationBarTitleDisplayMode(.inline)
            // TO DO: add searchable
        }
    }
}

struct PersonsManagementView_swift_Previews: PreviewProvider {
    static var previews: some View {
        let manager = TimeManager()
        let testPersons: [Person] = [
            Person(name: "SambaRock", timezone: TimeZone(identifier: "America/New_York") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "America/Sao_Paulo") ?? TimeZone(identifier: "GMT")!, color: .blue),
            Person(name: "Alex", timezone: TimeZone(identifier: "Europe/Lisbon") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb")
        ]
        
        manager.persons = testPersons
        
        return PersonsManagementView(manager: manager)
    }
}
