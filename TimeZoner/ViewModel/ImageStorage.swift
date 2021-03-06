//
//  ImageStorage.swift
//  TimeZoner
//
//  Created by tarrask on 19/10/2021.
//

import SwiftUI

class ImageStore {
    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    // MARK: - stores the image file in app memory and returns an image name
    func saveToUserDir(image: UIImage) -> String? {
        let imageName = UUID().uuidString
        if let data = image.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
            try? data.write(to: filename)
            return imageName
        } else {
            print("Failed storing image to User Directory")
        }
        return nil
    }
    
    // MARK: - reloads the image file from app memory and returns it
    func loadImage(imageName: String) -> UIImage? {
        let filename = getDocumentsDirectory().appendingPathComponent(imageName)

        guard let imageData = try? Data(contentsOf: filename), let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }
}
