//
//  TimeManager.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import SwiftUI

class TimeManager: ObservableObject {
    @Published var persons: [Person] = []
    
    /// Documents Folder
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    /// Path to info storage
    private static var infoURL: URL {
        documentsFolder.appendingPathComponent("persons.data")
    }
    
    /// Loads stored data
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.infoURL) else { return }

            guard let persons = try? JSONDecoder().decode([Person].self, from: data) else {
                fatalError("Can't decode saved refuel data.")
            }
            DispatchQueue.main.async {
                self?.persons = persons
            }
        }
    }
    
    /// Saves data into storage
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let persons = self?.persons else { fatalError("Self out of scope") }
            guard let data = try? JSONEncoder().encode(persons) else { fatalError("Error encoding refuelsdata") }
            do {
                let outfile = Self.infoURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write refuels to file")
            }
        }
    }
}
