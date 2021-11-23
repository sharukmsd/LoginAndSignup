//
//  ValidationManager.swift
//  LoginAndSignup
//
//  Created by Sharuk on 22/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ValidationManager{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func isValidName(name: String) -> Bool {
        return name.isEmpty ? false : true
    }
    
    func isValidEmail(email: String) -> Bool {
        if email.isEmpty{
            return false
        }
        if isValidEmailReg(email){
            return true
        }
        return false
    }
    
    func isValidPassword(password: String) -> Bool {
        if password.isEmpty{
            return false
        }
        if password.count >= 8{
            return true
        }
        return false
    }
    
    func isValidPhoneNumber(phone: String) -> Bool {
        if phone.isEmpty{
            return false
        }
        if phone.count == 11{
            return true
        }
        return false
    }
    
    func isValidDate(date: String) -> Bool {
        return date.isEmpty ? false : true
    }
    //Checks if email already exist in CoreData
    func isEmailExistAlready(email: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    //Validates email for regular expression
    private func isValidEmailReg(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
