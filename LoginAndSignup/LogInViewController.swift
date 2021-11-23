//
//  LogInViewController.swift
//  LoginAndSignup
//
//  Created by Sharuk on 07/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import UIKit
import CoreData

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var passErrLabel: UILabel!
    
    
    let validationManager = ValidationManager()
    let dbManager = DatabaseManager()
    //radius for textfields and button
    let radius = 22

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hides the keyboard on Tap
        initializeHideKeyboard()
        
        //set radius
        emailTextField.layer.cornerRadius = CGFloat(radius)
        passwordTextField.layer.cornerRadius = CGFloat(radius)
        enterButton.layer.cornerRadius = CGFloat(radius)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeHideKeyboard() {
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(Tap)
    }
    
    //obj func for Dismiss keyboard
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    @IBAction func enterTapped(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        //Check if email is valid
        if(validationManager.isValidEmail(email: email!)){
            emailErrLabel.isHidden = true
        }else{
            emailErrLabel.isHidden = false
            return;
        }
        
        //Check if password is 8 char long
        if(validationManager.isValidPassword(password: password!)){
            passErrLabel.isHidden = true
        }else{
            passErrLabel.isHidden = false
            return;
        }
        
        if(isUser(email: email!, password: password!)){
            
            //Store on local file that this user is logged in
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.set(email!, forKey: "loggedInUserEmail")
            UserDefaults.standard.synchronize()
            
            // dismisses itself
            self.dismiss(animated: true, completion: nil)
            
        }else{
            //To Do - Show error
            passErrLabel.text = "No user with this email or password"
            passErrLabel.isHidden = false
            return
        }
    }
    
    
    @IBAction func SignupTapped(_ sender: Any) {
        // If error labels are shown hide them
        if(emailErrLabel.isHidden == false || passErrLabel.isHidden == false){
            emailErrLabel.isHidden = true
            passErrLabel.isHidden = true
        }
        
        //Set fields empty
        emailTextField.text = ""
        passwordTextField.text = ""
//        self.dismiss(animated: true, completion: nil)
    }
    
    func isUser(email: String, password: String) -> Bool {
        var isUserFlag = false
        let res = dbManager.getUserWithEmail(email: email)
        for person in res {
            if(email == person.value(forKey: "email") as! String && password==person.value(forKey: "password") as! String){
                    isUserFlag = true
                    break
                }
                
            }
        return isUserFlag
    }

}
