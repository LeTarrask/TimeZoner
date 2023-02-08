//
//  MainView.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var manager: TimeManager = TimeManager.shared
    @State var addPerson: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button("clear") {
                    manager.clear()
                }
                
                Spacer()
                
                Button("Add Person") {
                    addPerson.toggle()
                }
                .padding()
            }
            
            Spacer()
            
            Watch(manager: manager)
                .edgesIgnoringSafeArea(.all)
                .sheet(isPresented: $addPerson, content: {
                    AddPersonView(manager: manager)
                })
            
            Spacer()
        }.onAppear(perform: manager.load)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
