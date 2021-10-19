//
//  PersonsManagementView.swift
//  TimeZoner
//
//  Created by tarrask on 19/10/2021.
//

import SwiftUI

struct PersonsManagementView: View {
    @ObservedObject var manager: TimeManager
    
    @State private var searchText = ""
    
    var list: some View {
        List {
            ForEach(manager.persons) { person in
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        if (person.imagePath != nil) {
                            Image(person.imagePath!)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 30, height: 30, alignment: .leading)
                        }
                        Text(person.name)
                            .font(.headline)
                    }
                    
                    Text(person.timezone.identifier)
                        .font(.subheadline)
                }
            }
            .onDelete(perform: removeRows)
        }
        .navigationTitle("Your current timezones")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                list
                    .searchable(text: $searchText)
            } else {
                list
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        manager.persons.remove(atOffsets: offsets)
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
