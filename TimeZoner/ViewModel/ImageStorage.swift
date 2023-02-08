//
//  ImageStorage.swift
//  TimeZoner
//
//  Created by tarrask on 19/10/2021.
//

import SwiftUI

class ImageStore: ObservableObject {
    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    static let shared = ImageStore()
    
    // MARK: - stores the image file in app memory and returns an image name
    func saveToUserDir(image: UIImage) -> String? {
        let imageName = UUID().uuidString

        if let data = image.resizeWithWidth(width: 100)?.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
            do {
                try data.write(to: filename)
            } catch {
                print(error.localizedDescription)
            }
            
            print("Saved image \(imageName) on \(filename)")
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

extension UIImage {
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
