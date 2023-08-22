import SwiftUI
import Foundation

struct ImageStore {
    static func saveImage(imageData: Data, id: UUID, directory: URL) {
        do {
            let imageURL = directory.appendingPathComponent("\(id.uuidString).jpg")
            try imageData.write(to: imageURL)
        } catch {
            print("Error saving image: \(error)")
        }
    }
}
