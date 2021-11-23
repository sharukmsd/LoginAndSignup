//
//  DatabaseManager.swift
//  LoginAndSignup
//
//  Created by Sharuk on 23/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    //Create
    func createNewUser(fName:String, email:String, password:String, phone: String, dateOfBirth: Date) -> Bool {
        let newPerson = Person(context: context)
        
        newPerson.fullName = fName
        newPerson.email = email
        newPerson.password = password
        newPerson.phone = phone
        newPerson.dateOfBirth = dateOfBirth as NSDate
        
        do{
            try context.save()
            print ("Saved")
            return true;
        }catch let error as NSError{
            print ("Could Not Save \(error)")
            return false
        }

    }
    
    //Retrive
    func getUserWithEmail(email: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results
    }
    func getAllUsers() -> NSFetchedResultsController<Person> {
        var fetchedResultsController: NSFetchedResultsController<Person>!

        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "fullName", ascending: true)
        ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: 
            context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to fetch data")
        }
        return fetchedResultsController
    }
    
    //Update
    func updateUser(userToUpdate: Person, name:String, email:String, password:String, phone: String, dateOfBirth: NSDate) -> Void {
        userToUpdate.fullName = name
        userToUpdate.email = email
        userToUpdate.password = password
        userToUpdate.phone = phone
        userToUpdate.dateOfBirth = dateOfBirth
        
        do {
            try context.save()
        } catch  {
            print("Error: Could not update user")
        }
    }
    
    //Delete
    func deleteUser(userToDelete: NSManagedObject) -> Void {
        context.delete(userToDelete)
        
        do {
            try context.save()
        } catch {
            print("Error: Unable to delete user")
        }
    }
}
