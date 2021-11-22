//
//  ValidationManager.swift
//  LoginAndSignup
//
//  Created by Sharuk on 22/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import Foundation
class ValidationManager{
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
    //Validates email for regular expression
    private func isValidEmailReg(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
