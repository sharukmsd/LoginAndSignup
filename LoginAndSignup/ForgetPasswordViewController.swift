//
//  ForgetPasswordViewController.swift
//  LoginAndSignup
//
//  Created by Sharuk on 23/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblErrEmail: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    
    let dbManager = DatabaseManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeHideKeyboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hides the keyboard on Tap on screen anywhere
    func initializeHideKeyboard() {
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(Tap)
    }
    
    //func for Dismissing keyboard
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    @IBAction func onBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onSearchTapped(_ sender: Any) {
        let email = txtEmail.text
        let res = dbManager.getUserWithEmail(email: email!)
        var isEmailFound = false
        for user in res{
            let emailFromDb = user.value(forKey: "email") as! String
            let password = user.value(forKey: "password") as! String
            if(email == emailFromDb){
                isEmailFound = true
                let showPassword = UIAlertController(title: "Show password", message: "Password for \(email!) is:\n \(password)", preferredStyle: UIAlertControllerStyle.alert)
                
                showPassword.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                present(showPassword, animated: true, completion: nil)
            }
        }
        if(isEmailFound == false){
            lblErrEmail.isHidden = false
            return
        }

    }
    
    @IBAction func txtEmailStartEditing(_ sender: Any) {
        lblErrEmail.isHidden = true

    }
    

}
