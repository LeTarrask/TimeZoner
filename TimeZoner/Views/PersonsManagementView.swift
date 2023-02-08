//
//  PersonsManagementView.swift
//  TimeZoner
//
//  Created by tarrask on 19/10/2021.
//

import SwiftUI

struct PersonsManagementView: View {
    @ObservedObject var manager = TimeManager.shared
    
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
                        
                        // TO DO: Customize country flag by locale
                        Text(person.flag ?? "")
                        
                        Spacer()
                        
                        Text(person.localTime())
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
        manager.save()
    }
}

struct PersonsManagementView_swift_Previews: PreviewProvider {
    static var previews: some View {
        let testPersons: [Person] = [
            Person(name: "SambaRock", timezone: TimeZone(identifier: "America/New_York") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba", flag: "🇵🇹"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "America/Sao_Paulo") ?? TimeZone(identifier: "GMT")!, color: .blue),
            Person(name: "Alex", timezone: TimeZone(identifier: "Europe/Lisbon") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb", flag: "🇨🇺"),
            Person(name: "SambaRock", timezone: TimeZone(identifier: "America/Argentina/Catamarca") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba", flag: "🇨🇺"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "Asia/Amman") ?? TimeZone(identifier: "GMT")!, color: .blue, flag: "🇵🇹"),
            Person(name: "Alex", timezone: TimeZone(identifier: "Asia/Phnom_Penh") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb"),
            Person(name: "SambaRock", timezone: TimeZone(identifier: "Antarctica/Palmer") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba", flag: "🇨🇺"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "Europe/Budapest") ?? TimeZone(identifier: "GMT")!, color: .blue, flag: "🇵🇹"),
            Person(name: "Alex", timezone: TimeZone(identifier: "Indian/Antananarivo") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb"),
            Person(name: "SambaRock", timezone: TimeZone(identifier: "Indian/Maldives") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba", flag: "🇵🇹"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "Pacific/Wallis") ?? TimeZone(identifier: "GMT")!, color: .blue, flag: "🇨🇺")
        ]
        
        let personView = PersonsManagementView()
        
        personView.manager.persons = testPersons
        
        personView.manager.sortPersons()
        
        return personView
    }
}
