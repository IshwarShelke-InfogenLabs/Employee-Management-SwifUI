import SwiftUI
import os

@MainActor
class EmployeeStore: ObservableObject {
    @Published var empArr: [EmpProfile] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("employees.data")
    }
 
    func load() async throws {
        let task = Task<[EmpProfile], Error> {
            let fileURL = try Self.fileURL()
            print("FileURL: ",fileURL)
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let empData = try JSONDecoder().decode([EmpProfile].self, from: data)
            return empData
        }
        let empArr = try await task.value
        self.empArr = empArr
    }
    
    func save(empArr: [EmpProfile]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(empArr)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
