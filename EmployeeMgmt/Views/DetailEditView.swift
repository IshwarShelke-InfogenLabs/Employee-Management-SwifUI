import SwiftUI
import UIKit

struct DetailEditView: View {
    @Binding var emp: EmpProfile
    @Binding var empArr: [EmpProfile]
    @Binding var checkIfDuplicate: Bool
    @Binding var alertOnDuplicate: Bool
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var empIdInput = ""
    
    // Specify the directory URL
    let imageDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("EmployeeImages")
    
    private func setupEmpIdInput() {
        empIdInput = String(emp.empId)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Employee Info")) {
                HStack {
                    Text("Employee Age:")
                    TextField("Employee Age", value: $emp.empAge, formatter: NumberFormatter())
                }
                
                HStack {
                    Text("Designation:")
                    TextField("Designation", text: $emp.empDesignation)
                }
                
                HStack {
                    Text("Project:")
                    TextField("Project", text: $emp.empProject)
                }
                
                HStack {
                    Text("Employee ID:")
                    
                    TextField("Employee ID", text: $empIdInput)
                        .keyboardType(.numberPad)
                        .onChange(of: empIdInput) { newValue in
                            handleEmpIdChange(newValue)
                        }
                        .alert(isPresented: $alertOnDuplicate) {
                            Alert(
                                title: Text("Duplicate Entry"),
                                message: Text("An employee with the same ID already exists."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                }
                
                HStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        if let uiImage = emp.loadImage() {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Text("No image present")
                        }
                    }

                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text("Select Image")
                    }
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
        }
        .onAppear{
            setupEmpIdInput()
        }
    }
    
    private func handleEmpIdChange(_ newValue: String) {
        if let newId = Int(newValue) {
            emp.empId = newId
            checkIfDuplicate = isDuplicateEmpId(newId)
        } else {
            emp.empId = 0
        }
    }

  
    func loadImage() {
        if let image = selectedImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                let imageID = UUID() // Generate a unique ID for the image
                ImageStore.saveImage(imageData: imageData, id: imageID, directory: imageDirectoryURL)
                emp.empImageID = imageID
                print("Image dimensions: \(image.size)")
            }
            print(imageDirectoryURL)
        }
    }

    
    func isDuplicateEmpId(_ id: Int) -> Bool {
        let duplicateEmp = empArr.first { $0.empId == id }
        return duplicateEmp != nil
    }
}


struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(emp: .constant(EmpProfile.sampleData[0]),empArr: .constant(EmpProfile.sampleData),checkIfDuplicate: .constant(false),alertOnDuplicate: .constant(false))
    }
}
