import SwiftUI
import CoreData

// MARK: - ViewModel
class MainViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var addDepartment = false
    @Published var addEmployee = false
    
    @Published var departments: [Company] = []
    
    private let viewContext: NSManagedObjectContext
    private var notificationToken: NSObjectProtocol?

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchDepartments()
        listenForChanges()
    }
    
    func fetchDepartments() {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Company.name, ascending: true)]
        
        do {
            self.departments = try viewContext.fetch(request)
        } catch {
            print("Error fetching companies: \(error.localizedDescription)")
        }
    }
    
    var filteredDepartments: [Company] {
        if searchText.isEmpty {
            return departments
        } else {
            return departments.filter { department in
                let matchesDepartment = (department.name?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                                        (department.location?.localizedCaseInsensitiveContains(searchText) ?? false)
                
                let matchesEmployee = department.employee.contains { employee in
                    employee.name?.localizedCaseInsensitiveContains(searchText) ?? false
                }
                
                return matchesDepartment || matchesEmployee
            }
        }
    }
    
    func deleteDepartment(at offsets: IndexSet) {
        for index in offsets {
            let departmentToDelete = departments[index]
            viewContext.delete(departmentToDelete)
            saveContext()
        }
    }

    func saveContext() {
        do {
            try viewContext.save()
            fetchDepartments() // Ensure the UI updates immediately
            objectWillChange.send() // Notify UI to refresh
        } catch {
            print("Error saving Core Data context: \(error.localizedDescription)")
        }
    }
    
    private func listenForChanges() {
        notificationToken = NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextObjectsDidChange,
            object: viewContext,
            queue: .main
        ) { _ in
            self.fetchDepartments() // Re-fetch when Core Data changes
            self.objectWillChange.send() // Notify SwiftUI
        }
    }
}
