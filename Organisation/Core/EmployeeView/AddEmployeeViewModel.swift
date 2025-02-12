//
//  AddEmployeeViewModel.swift
//  Organisation
//
//  Created by Celestial on 10/02/25.
//

import SwiftUI
import CoreData

//MARK: - EmployeeViewModel
class AddEmployeeViewModel: ObservableObject {
    @Published var personName = ""
    @Published var personImage = UIImage()
    @Published var personAge = ""
    @Published var selectedCompany: Company?
    @Published var personSignature = UIImage()
    
    private var viewContext: NSManagedObjectContext
    var employee: Employee?
    
    init(viewContext: NSManagedObjectContext, employee: Employee? = nil) {
        self.viewContext = viewContext
        self.employee = employee
        
        if let employee = employee {
            loadEmployeeData(employee)
        }
    }
    
    private func loadEmployeeData(_ employee: Employee) {
        personName = employee.name ?? ""
        personAge = employee.age > 0 ? String(employee.age) : ""
        selectedCompany = employee.employeeToCompany
        
        if let imageData = employee.profileImage, let uiImage = UIImage(data: imageData) {
            personImage = uiImage
        }
        
        if let signatureData = employee.signature, let uiImage = UIImage(data: signatureData) {
            personSignature = uiImage
        }
    }
    
    func saveEmployee() {
        let newEmployee = Employee(context: viewContext)
        newEmployee.id = UUID()
        newEmployee.name = personName
        newEmployee.age = Int64(personAge) ?? 0
        newEmployee.profileImage = personImage.pngData()
        newEmployee.signature = personSignature.pngData()
        newEmployee.employeeToCompany = selectedCompany

        saveContext()
    }


    func updateEmployee() {
        guard let employee = employee else { return }
        employee.name = personName
        employee.age = Int64(personAge) ?? 0
        employee.profileImage = personImage.pngData()
        employee.signature = personSignature.pngData()
        employee.employeeToCompany = selectedCompany

        saveContext()
    }


    private func saveContext() {
        do {
            try viewContext.save()
            DispatchQueue.main.async {
                self.viewContext.refreshAllObjects() // Refresh Core Data objects
                self.objectWillChange.send() // Notify UI update
            }
        } catch {
            print("Error saving/updating employee: \(error.localizedDescription)")
        }
    }


}
