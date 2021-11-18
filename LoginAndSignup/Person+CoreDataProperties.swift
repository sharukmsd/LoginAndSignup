//
//  Person+CoreDataProperties.swift
//  LoginAndSignup
//
//  Created by Sharuk on 18/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var dateOfBirth: NSDate?

}
