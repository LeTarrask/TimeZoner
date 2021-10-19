//
//  AddPersonView.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import Foundation
import SwiftUI


struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var manager: TimeManager
    
    @State private var name: String = ""
    @State private var color: Color = .red
    @State var TZid: String = "none chosen"
    
    @State var pickerActive: Bool = false
    
    var image: Image?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose a person")) {
                    TextField("Person name", text: $name)
                    ColorPicker("Choose a color! 🎨", selection: $color)
                }
                
                Section(header: Text("Choose a timezone")) {
                    Text("Current zone -> \(TZid)")
                    NavigationLink("Change zone", destination: ZoneChooser(TZid: $TZid), isActive: $pickerActive)
                }
                
                Section(header: Text("Pick an image")) {
                    // TO DO: add an image picker here
                    // TO DO: convert image to thumbnail
                    
                }
                
                Section {
                    Button("Save") {
                        if let timezone = TimeZone.init(identifier: TZid) {
                            let person = Person(name: name, timezone: timezone, color: color, image: image)
                            manager.persons.append(person)
                            
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            print("Error saving person")
                        }
                    }
                }
            }.navigationBarTitle("Create a new timezone watch", displayMode: .inline)
        }
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView(manager: TimeManager())
    }
}


