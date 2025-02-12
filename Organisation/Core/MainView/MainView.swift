import SwiftUI
import CoreData

// MARK: - MainView
struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: MainViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: MainViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                
                List {
                    ForEach(viewModel.filteredDepartments) { department in
                        NavigationLink(destination:
                                        EmployeeListView(employees: department.employee, viewModel: viewModel)
                        ) {
                            HStack {
                                if let profileData = department.companyProfile,
                                   let image = UIImage(data: profileData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 60, height: 60)
                                }
                                VStack(alignment: .leading) {
                                    Text(department.name ?? "")
                                        .font(.title2)
                                    Text(department.location ?? "")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteDepartment)
                }
                .listStyle(PlainListStyle())
            }
           
            .navigationTitle("Organisation Go")
            .fullScreenCover(isPresented: $viewModel.addDepartment) {
                AddCompanyView(context: viewContext)
            }
            .fullScreenCover(isPresented: $viewModel.addEmployee) {
                AddEmployeeView()
            }
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.addDepartment.toggle() }) {
                        Label("Add Company", systemImage: "building")
                    }
                    Button(action: { viewModel.addEmployee.toggle() }) {
                        Label("Add Employee", systemImage: "person.fill")
                    }
                }
            }
            .tint(.black)
        }
        .accentColor(.black)
    }
}

// MARK: - Employee List View
struct EmployeeListView: View {
    let employees: [Employee]
    @ObservedObject var viewModel: MainViewModel
    
    
    var body: some View {
        List(employees) { employee in
            NavigationLink(destination: AddEmployeeView(employee: employee, isViewer: true)) {
                EmployeeDetailCell(employee: employee)
                   
            }
            
        }
        .onAppear {
            viewModel.fetchDepartments()
        }
    }
}

// MARK: - Search Bar View
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search by name or location", text: $text)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 10)
    }
}

