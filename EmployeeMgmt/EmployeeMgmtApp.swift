//
//  EmployeeMgmtApp.swift
//  EmployeeMgmt
//
//  Created by Ishwar Shelke on 17/07/23.
//

import os
import SwiftUI

@main
struct EmployeeMgmtApp: App {
    @StateObject private var store = EmployeeStore()
    
    var body: some Scene {
        WindowGroup {
            UserView(empArr: $store.empArr){
                Task {
                    do {
                        try await store.save(empArr: store.empArr)
                        logToFile(message: "Data saved to the file")
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
            .task {
                do {
                    try await store.load()
                    logToFile(message: "Data loaded from the file")
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
