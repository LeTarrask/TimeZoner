//
//  TimeZonerApp.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import SwiftUI

@main
struct TimeZonerApp: App {
    @ObservedObject var manager: TimeManager = TimeManager()
    
    @State var addPerson: Bool = false
    
    var body: some Scene {
        WindowGroup {
            VStack {
                HStack {
                    Spacer()
                    
                    Button("Add Person") {
                        addPerson.toggle()
                    }
                }
                
                Spacer()
                
                Watch(manager: manager)
            }
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $addPerson, content: {
                AddPersonView(manager: manager)
            })
        }
    }
}
