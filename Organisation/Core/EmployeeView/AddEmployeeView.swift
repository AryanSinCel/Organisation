import SwiftUI
import CoreData

//MARK: EmployeeView
struct AddEmployeeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var viewModel: AddEmployeeViewModel
    @State private var imagePicker = false
    @State private var signaturePicker = false
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Company.name, ascending: true)]) private var companies: FetchedResults<Company>
    
    var isViewer: Bool
    
    init(employee: Employee? = nil, isViewer: Bool = false) {
        self._viewModel = StateObject(wrappedValue: AddEmployeeViewModel(viewContext: PersistenceController.shared.container.viewContext, employee: employee))
        self.isViewer = isViewer
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    Image(uiImage: viewModel.personImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.black, lineWidth: 3))
                        .frame(width: isViewer ? 400 : 100, height: isViewer ? 400 : 100)
                    
                    if !isViewer {
                        Button("Add Image") { imagePicker.toggle() }
                            .foregroundStyle(.black)
                            .sheet(isPresented: $imagePicker) {
                                ImagePicker(selectedImage: $viewModel.personImage)
                            }
                    }
                }
                
                TextField("Add Person Name", text: $viewModel.personName)
                TextField("Add Person Age", text: $viewModel.personAge)
                    .keyboardType(.decimalPad)
                
                Picker("Select Company", selection: $viewModel.selectedCompany) {
                    ForEach(companies, id: \ .self) { company in
                        Text(company.name ?? "").tag(company as Company?)
                    }
                }
                
                VStack {
                    Image(uiImage: viewModel.personSignature)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Rectangle().stroke(Color.black, lineWidth: 3))
                        .frame(height: 100)
                    
                    if !isViewer {
                        Button("Add Signature") { signaturePicker.toggle() }
                            .foregroundStyle(.black)
                            .sheet(isPresented: $signaturePicker) {
                                ImagePicker(selectedImage: $viewModel.personSignature)
                            }
                    }
                }
                
                if !isViewer {
                    Button(viewModel.employee == nil ? "Save Employee" : "Update Employee") {
                        if viewModel.employee == nil {
                            viewModel.saveEmployee()
                        } else {
                            viewModel.updateEmployee()
                        }
                        dismiss()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .background(Color.black)
                    .tint(.white)
                }
            }
            .navigationTitle(isViewer ? viewModel.employee?.name ?? "Employee" : (viewModel.employee == nil ? "Add Employee" : "Edit Employee"))
            .toolbar {
                if !isViewer {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: { dismiss() }) {
                            Label("Go Back", systemImage: "chevron.left")
                        }
                        .tint(.black)
                    }
                }
            }
        }
    }
}
