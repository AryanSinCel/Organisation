//
//  Company+CoreDataProperties.swift
//  Organisation
//
//  Created by Celestial on 06/02/25.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var companyProfile: Data?
    @NSManaged public var location: String?
    @NSManaged public var companyToEmployee: Set<Employee>?
    
    public var employee : [Employee]{
        let setOfEmployee = companyToEmployee
        return setOfEmployee!.sorted{
            $0.id > $1.id
        }
    }

}

// MARK: Generated accessors for companyToEmployee
extension Company {

    @objc(addCompanyToEmployeeObject:)
    @NSManaged public func addToCompanyToEmployee(_ value: Employee)

    @objc(removeCompanyToEmployeeObject:)
    @NSManaged public func removeFromCompanyToEmployee(_ value: Employee)

    @objc(addCompanyToEmployee:)
    @NSManaged public func addToCompanyToEmployee(_ values: NSSet)

    @objc(removeCompanyToEmployee:)
    @NSManaged public func removeFromCompanyToEmployee(_ values: NSSet)

}

extension Company : Identifiable {

}
