import SwiftUI
import CoreData

//MARK: - CompanyView
struct AddCompanyView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: AddCompanyViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: AddCompanyViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    Image(uiImage: viewModel.companyImage)
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 3)
                        }
                    Button {
                        viewModel.imagePicker.toggle()
                    } label: {
                        Text("Add Image")
                    }
                    .foregroundStyle(Color.black)
                    .sheet(isPresented: $viewModel.imagePicker) {
                        ImagePicker(selectedImage: $viewModel.companyImage)
                    }
                }
                
                TextField("Enter Department Name", text: $viewModel.companyName)
                TextField("Enter Your Location", text: $viewModel.companyLocation)
                
                Button {
                    viewModel.saveCompany()
                    dismiss()
                } label: {
                    Text("Save Department")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                .background(Color.black)
                .tint(.white)
            }
            .navigationTitle("Add Department")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Go Back", systemImage: "chevron.left")
                    }
                    .tint(Color.black)
                }
            }
        }
    }
}

#Preview {
    AddCompanyView(context: PersistenceController.shared.container.viewContext)
}
