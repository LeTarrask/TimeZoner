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
    
    @State var showingZonePicker: Bool = false
    
    let imageStore = ImageStore()
    @State var image: UIImage?
    @State var showingImagePicker: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose a person")) {
                    TextField("Person name", text: $name)
                    ColorPicker("Choose a color! 🎨", selection: $color)
                }
                
                Section(header: Text("Choose a timezone")) {
                    Text("Current zone -> \(TZid)")
                    NavigationLink("Change zone", destination: ZoneChooser(TZid: $TZid), isActive: $showingZonePicker)
                }
                
                Section(header: Text("Pick an image from your library")) {
                    // Image picker here, returns uiImage that's sent to addPhoto
                    Button("Choose an image") {
                        showingImagePicker.toggle()
                    }
                    
                    if image != nil {
                        Image(uiImage: image!)
                    }
                }
                
                Section {
                    Button("Save") {
                        if let timezone = TimeZone.init(identifier: TZid) {
                            var person = Person(name: name, timezone: timezone, color: color, imagePath: nil)
                            
                            if image != nil {
                                let path = imageStore.saveToUserDir(image: image!)
                                person.imagePath = path
                            }
                           
                            manager.persons.append(person)
                            manager.sortPersons()
                            
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            print("Error saving person")
                        }
                    }
                }
            }.navigationBarTitle("Create a new timezone watch", displayMode: .inline)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(sourceType: .photoLibrary, onImagePicked: { image in
                addPhoto(uiImage: image)
            })
        }
    }
    
    func addPhoto(uiImage: UIImage) -> Void {
        image = uiImage.scaleImage(toSize: CGSize(width: 30, height: 30)) 
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView(manager: TimeManager())
    }
}


