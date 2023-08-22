import Foundation
import SwiftUI


struct EmpProfile: Identifiable,Codable {
    var id: UUID
    var empName: String
    var empAge: Int
    var empDesignation: String
    var empProject: String
    var empId: Int
    var empImageID: UUID? // Store the unique ID of the image

    init(id: UUID = UUID(), empName: String, empAge: Int, empDesignation: String, empProject: String, empId: Int) {
        self.id = id
        self.empName = empName
        self.empAge = empAge
        self.empDesignation = empDesignation
        self.empProject = empProject
        self.empId = empId
    }
}

extension EmpProfile {
    func loadImage() -> UIImage? {
        guard let imageID = empImageID else {
            return nil
        }
        
        if let imageUrl = getImageUrl(imageID: imageID),
           let imageData = try? Data(contentsOf: imageUrl),
           let uiImage = UIImage(data: imageData) {
            return uiImage
        }
        
        return nil
    }
    
    
    private func getImageUrl(imageID: UUID) -> URL? {
        if let imagesDirectory = getImagesDirectory() {
            return imagesDirectory.appendingPathComponent("\(imageID).jpg")
        }
        return nil
    }
    
    private func getImagesDirectory() -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagesDirectory = documentDirectory?.appendingPathComponent("EmployeeImages")
        do {
            try fileManager.createDirectory(at: imagesDirectory!, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating EmployeeImages directory: \(error.localizedDescription)")
            return nil
        }
        return imagesDirectory
    }
}


extension EmpProfile {
    static var emptyEmp: EmpProfile{
        EmpProfile(empName: "", empAge: 23, empDesignation: "", empProject: "", empId: 0)
    }
}

extension EmpProfile {
    static let sampleData: [EmpProfile] =
    [
        EmpProfile(empName: "Ishwar", empAge: 22, empDesignation: "Soft Engg", empProject: "Retail", empId: 123)
    ]
}
