//
//  LogInViewController.swift
//  LoginAndSignup
//
//  Created by Sharuk on 07/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var passErrLabel: UILabel!
    
    //radius for textfields and button
    let radius = 22

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

    @IBAction func enterTapped(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        //Check if email is valid
        if (email?.isEmpty)!{
            emailErrLabel.isHidden = false
        }
        if((email?.contains("@"))!){
            emailErrLabel.isHidden = false
        }
        
        //Check if password is 8 char long
        if (password?.isEmpty)!{
            passErrLabel.isHidden = false
        }
        
        
        //Validate credientals provided
        
        //If valid dismisses itself
    }
    
    
    @IBAction func SignupTapped(_ sender: Any) {
        // If error labels are shown hide them
        if(emailErrLabel.isHidden == false || passErrLabel.isHidden == false){
            emailErrLabel.isHidden = true
            passErrLabel.isHidden = true
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
