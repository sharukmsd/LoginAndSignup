//
//  SignUpViewController.swift
//  LoginAndSignup
//
//  Created by Sharuk on 07/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rPasswordTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var fNameErrLabel: UILabel!

    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var passErrLabel: UILabel!
    @IBOutlet weak var rPassErrLabel: UILabel!
    let radius = 22
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fNameTextField.layer.cornerRadius = CGFloat(radius)
        emailTextField.layer.cornerRadius = CGFloat(radius)
        passwordTextField.layer.cornerRadius = CGFloat(radius)
        rPasswordTextField.layer.cornerRadius = CGFloat(radius)
        goButton.layer.cornerRadius = CGFloat(radius)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func goTapped(_ sender: Any) {
        //on tapping the Go button
        let fullName = fNameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let rPassword = rPasswordTextField.text
        //Check for empty fields
        if (fullName?.isEmpty)!{
            fNameErrLabel.isHidden = false
        }
        if (email?.isEmpty)!{
            emailErrLabel.isHidden = false
        }
        if (password?.isEmpty)!{
            passErrLabel.isHidden = false
        }
        if (rPassword?.isEmpty)!{
            rPassErrLabel.isHidden = false
        }
        
        //Check if email is valid
        if((email?.contains("@"))!){
            emailErrLabel.isHidden = false
        }
        
        //Passwod must be 8 character long
        if let password = passwordTextField.text, password.count >= 8{
            passErrLabel.isHidden = false
        }
        
        //Check values of  password and repeat password matches or not
        if(password != rPassword){
            rPassErrLabel.isHidden = false
        }
        //Store data
    }
    @IBAction func loginTapped(_ sender: Any) {
        //On tapping the login
        // Dissmiss itself
        self.dismiss(animated: true, completion: nil)
    }
    

}
