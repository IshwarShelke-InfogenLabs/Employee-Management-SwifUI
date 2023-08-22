import Foundation
import SwiftUI

struct AddEmployeeForm: View {
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var empId: String = ""
    @Binding var empArr: [EmpProfile]
    @State private var newEmp = EmpProfile.emptyEmp
    @Binding var showingDetail: Bool
    @State private var showAlertForIncompleteDetails = false
    @State private var showAlertForDuplicateID = false
    @State private var isDuplicate: Bool = false
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Employee ID", text: $empId)
                }
            }
            .alert(isPresented: $showAlertForDuplicateID) {
                Alert(
                    title: Text("EmployeeID already exists!!"),
                    message: Text("Please add unique ID"),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            Section {
                HStack{
                    Button {
                        logToFile(message: "Submit form clicked")
                        submitForm()
                    } label: {
                        Text("Confirm")
                    }
                    .alert(isPresented: $showAlertForIncompleteDetails) {
                        Alert(
                            title: Text("Invalid Input"),
                            message: Text("Please fill all of the details!!"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    Spacer()
                    
                    Button {
                        showingDetail = false
                    } label: {
                        Text("Cancel")
                    }
                }
                .padding()
            }
        }
    }
    
    func submitForm() {
        if name.isEmpty || empId.isEmpty {
            showAlertForIncompleteDetails = true
//            print(showAlertForIncompleteDetails)
        }
        else{
            isDuplicate = isDuplicateEmpId(Int(empId) ?? 0)
            if isDuplicate{
                showAlertForDuplicateID = true
            }
            else{
                newEmp.empName = name
                newEmp.empId = Int(empId) ?? 0
                logToFile(message: "Form is submitted")
                empArr.append(newEmp)
                
                // Reset the form fields
                name = ""
                age = ""
                showingDetail = false
            }
        }
    }
    
    func isDuplicateEmpId(_ id: Int) -> Bool {
        let duplicateEmp = empArr.first { $0.empId == id }
        return duplicateEmp != nil
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        AddEmployeeForm(empArr: .constant(EmpProfile.sampleData), showingDetail: .constant(true))
    }
}
