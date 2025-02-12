//
//  AddCompanyViewModel.swift
//  Organisation
//
//  Created by Celestial on 10/02/25.
//

import SwiftUI
import CoreData

//MARK: - CompanyViewModel
class AddCompanyViewModel: ObservableObject {
    @Published var companyName = ""
    @Published var companyImage = UIImage()
    @Published var companyLocation = ""
    @Published var imagePicker = false
    
    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func saveCompany() {
        let department = Company(context: viewContext)
        department.id = UUID()
        department.name = companyName
        department.location = companyLocation
        department.companyProfile = companyImage.pngData()
        
        do {
            try viewContext.save()
        
        } catch {
            print("Error saving company: \(error.localizedDescription)")
        }
    }
}
