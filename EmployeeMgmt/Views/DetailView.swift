//  EmployeeDetailView.swift
//  EmployeeMgmt
//  Created by Ishwar Shelke on 17/07/2

import SwiftUI

struct DetailView: View {
    @Binding var emp: EmpProfile
    @Binding var empArr: [EmpProfile]
    @State private var isPresentingEditView = false
    @State private var editingEmp = EmpProfile.emptyEmp
    @State private var checkIfDuplicate = false
    
    @State private var alertOnDuplicate = false
    
    
    var body: some View {
        VStack(alignment: .center){
            Form{
                HStack {
                    Spacer()
                    if let uiImage = emp.loadImage() {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } else {
                        Label("", systemImage: "person")
                    }
                    Spacer()
                }
                .frame(alignment: .center)

                HStack(alignment: .center) {
                    Text("Name: \(emp.empName)")
                }
                
                HStack(alignment: .center) {
                    Text("Age: \(emp.empAge)")
                }
                
                HStack(alignment: .center) {
                    Text("Designation: \(emp.empDesignation)")
                }
                
                HStack(alignment: .center) {
                    Text("Project: \(emp.empProject)")
                }
                
                HStack(alignment: .center) {
                    Text("Employee ID: \(emp.empId)")
                }
            }
            .toolbar {
                Button("Edit") {
                    isPresentingEditView = true
                    editingEmp = emp
                    logToFile(message: "Edit button Clicked")
                }
            }
            .sheet(isPresented: $isPresentingEditView) {
                NavigationStack {
                    DetailEditView(emp: $editingEmp,empArr: $empArr,checkIfDuplicate: $checkIfDuplicate,alertOnDuplicate: $alertOnDuplicate)
                        .navigationTitle(emp.empName)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isPresentingEditView = false
                                    logToFile(message: "Cancel button Clicked")
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    if checkIfDuplicate{
                                        alertOnDuplicate = true
                                    }
                                    else{
                                        isPresentingEditView = false
                                        emp = editingEmp
                                        logToFile(message: "Done button Clicked")
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(emp: .constant(EmpProfile.sampleData[0]),empArr: .constant(EmpProfile.sampleData))
    }
}
