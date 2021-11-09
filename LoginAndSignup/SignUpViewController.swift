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
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    //Labels used to show invalid input
    @IBOutlet weak var fNameErrLabel: UILabel!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var passErrLabel: UILabel!
    @IBOutlet weak var rPassErrLabel: UILabel!
    @IBOutlet weak var phoneErrLabel: UILabel!
    @IBOutlet weak var dateErrLabel: UILabel!
    
    
    let radius = 22 //corner radius value for textfield and button
    private var datePicker: UIDatePicker!
    
    fileprivate func setUpDatePicker() {
        //Date Picker initialization
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    
    fileprivate func setRadius() {
        fNameTextField.layer.cornerRadius = CGFloat(radius)
        emailTextField.layer.cornerRadius = CGFloat(radius)
        passwordTextField.layer.cornerRadius = CGFloat(radius)
        rPasswordTextField.layer.cornerRadius = CGFloat(radius)
        goButton.layer.cornerRadius = CGFloat(radius)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hides the keyboard on Tap
        initializeHideKeyboard()
        
        //sets radius of input fiedls and button
        setRadius()
        
        //Initlize date Picker
        setUpDatePicker()
        
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
    
    //obj func for Dismiss keyboard
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
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
        let phone = phoneTextField.text
        let dateOfBirth = dateTextField.text
        
        //Check for empty fields
        if (fullName?.isEmpty)!{
            fNameErrLabel.isHidden = false
            return;
        }else{
            fNameErrLabel.isHidden = true
        }
        if (email?.isEmpty)!{
            emailErrLabel.isHidden = false
            return;
        }
        if (password?.isEmpty)!{
            passErrLabel.isHidden = false
            return;
        }
        if (rPassword?.isEmpty)!{
            rPassErrLabel.isHidden = false
            return;
        }
        if (phone?.isEmpty)!{
            phoneErrLabel.isHidden = false
            return;
        }
        if (dateOfBirth?.isEmpty)!{
            dateErrLabel.isHidden = false
            return;
        }
        
        //Check if email is valid
        if(isValidEmail(email!)){
            emailErrLabel.isHidden = true
        }else{
            emailErrLabel.isHidden = false
            return;
        }
        
        //Passwod must be 8 character long
        if let password = passwordTextField.text, password.count >= 8{
            passErrLabel.isHidden = true
        }else{
            passErrLabel.isHidden = false
            return;
        }
        
        //Check values of  password and repeat password matches or not
        if(password != rPassword){
            rPassErrLabel.isHidden = false
            return;
        }else{
            rPassErrLabel.isHidden = true
        }
        
        //Store data
        let isStored = storeData(fName: fullName!, email: email!, password: password!)
        if isStored{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        //On tapping the login
        // Dissmiss itself
        self.dismiss(animated: true, completion: nil)
    }
    
    //Stores data in UserDefaults
    func storeData(fName:String, email:String, password:String) -> Bool {
        UserDefaults.standard.set(fName, forKey: "fullName")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "passWord")
//        print(UserDefaults.standard.string(forKey: "passWord") ?? "pass")

        UserDefaults.standard.synchronize();
        return true;
    }
    
    //Validates email for regular expression
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    

}
