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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        if (email?.isEmpty)!{
            emailErrLabel.isHidden = false
            return;
        }
        if(isValidEmail(email!)){
            emailErrLabel.isHidden = true
            
        }else{
            emailErrLabel.isHidden = false
            return
        }
        
        //Check if password is 8 char long
        if (password?.isEmpty)!{
            passErrLabel.isHidden = false
            return;
        }
        
        
        //Validate credientals provided
//        let storedEmail = UserDefaults.standard.string(forKey: "email")
//        let storedPassword = UserDefaults.standard.string(forKey: "passWord")
//
//        print(storedEmail! + " " + email! ?? nil)
//        print(storedPassword! + " " + password! ?? nil)
        
        if(isUser(email: email!, password: password!)){
            
            //Store on local file that this user is logged in
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            
            // dismisses itself
            self.dismiss(animated: true, completion: nil)
            
        }else{
            //To Do - Show error
            passErrLabel.text = "Password is incorrect"
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
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isUser(email: String, password: String) -> Bool {
        
        do {
            let res = try context.fetch(Person.fetchRequest())
            for person in res as! [NSManagedObject]{
                print(person.value(forKey: "fullName") as! String)
                print(person.value(forKey: "email") as! String)
                print(person.value(forKey: "password") as! String)
                print(person.value(forKey: "phone") as! String)
                print(person.value(forKey: "dateOfBirth") as! Date)
            }
            return true
        } catch {
            print("Could not auth")
            return false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
