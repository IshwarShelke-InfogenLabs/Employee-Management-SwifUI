//
//  ContentView.swift
//  EmployeeMgmt
//
//  Created by Ishwar Shelke on 17/07/23.
//

import SwiftUI

struct UserView: View {
    @Binding var empArr: [EmpProfile]
    @State var showingDetail = false
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void
    @State private var showActionSheet = false

    var body: some View {
        NavigationView {
            VStack {
                if !empArr.isEmpty {
                    List {
                        ForEach($empArr) { $emp in
                            NavigationLink(destination: DetailView(emp: $emp,empArr: $empArr)) {
                                if let uiImage = emp.loadImage() {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    Label("", systemImage: "person")
                                }
                                
                                
                                VStack(alignment: .leading){
                                    Text("\(emp.empName)")
                                    Text("Age: \(emp.empAge)")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                        }
                        .onDelete(perform: deleteEmpArr)
                    }
                } else {
                    Text("Nothing to show :(")
                }
                
                HStack {
                    VStack {
                        Button("Sort  |") {
                            showActionSheet = true
                        }
                    }
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("Choose an option"), buttons: [
                            .default(Text("Sort by Age Asc"), action: {
                                sortEmpArrByAgeAsc()
                            }),
                            .default(Text("Sort by Age Dsc"), action: {
                                sortEmpArrByAgeDsc()
                            }),
                            .default(Text("Sort by Name A-Z"), action: {
                                sortEmpArrByNameAsc()
                            }),
                            .default(Text("Sort by Name Z-A"), action: {
                                sortEmpArrByNameDsc()
                            }),
                            .cancel()
                        ])
                    }
                    
                    Button(action: {
                        logToFile(message: "Add a new user")
                        self.showingDetail = true
                    }) {
                        Text("Add Employee")
                    }
                    .sheet(isPresented: $showingDetail) {
                        AddEmployeeForm(empArr: $empArr, showingDetail: $showingDetail)
                    }
                    .onChange(of: scenePhase) { phase in
                        if phase == .inactive { saveAction() }
                    }
                }
            }
            .navigationTitle("All Employees")
        }
    }
    
    func sortEmpArrByAgeAsc() {
        empArr.sort { $0.empAge < $1.empAge }
    }

    func sortEmpArrByAgeDsc() {
        empArr.sort { $0.empAge > $1.empAge }
    }
    
    func sortEmpArrByNameAsc() {
        empArr.sort { $0.empName < $1.empName }
    }

    func sortEmpArrByNameDsc() {
        empArr.sort { $0.empName > $1.empName }
    }
    
    func deleteEmpArr(at offsets: IndexSet) {
        empArr.remove(atOffsets: offsets)
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(empArr: .constant(EmpProfile.sampleData), saveAction: {})
    }
}
