//
//  SignUpViewController.swift
//  LoginAndSignup
//
//  Created by Sharuk on 07/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {

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
    
    
    private var datePicker: UIDatePicker!
    var activeTextField : UITextField? = nil
    
    let validationManager = ValidationManager()

    let dbManager = DatabaseManager()
    
    fileprivate func setUpDatePicker() {
        //Date Picker initialization
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
    }

    //Delegates used for scrolling textField above keyboard
    fileprivate func setDelegates() {
        fNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        rPasswordTextField.delegate = self
        phoneTextField.delegate = self
        dateTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        
        //Hides the keyboard on Tap
        initializeHideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
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
    
    // Fired when user start typing in textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    // Fired when user end typing in textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
        dismissMyKeyboard()
    }
    
    //When keybaord will appear
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if let activeTextField = activeTextField{
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardFrame.height
            
            if bottomOfTextField > topOfKeyboard{
                self.view.frame.origin.y -= keyboardFrame.height
            }
            
        }
    }
    //When keybaord will disappear
    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
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
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
//        view.endEditing(true)
    }
    
    
    @IBAction func goTapped(_ sender: Any) {
        //on tapping the Go button
        let fullName = fNameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let rPassword = rPasswordTextField.text
        let phone = phoneTextField.text
        let dateOfBirth = datePicker.date
        
        //Validations
        if (validationManager.isValidName(name: fullName!)){
            fNameErrLabel.isHidden = true
        }else{
            fNameErrLabel.isHidden = false
            return;
        }
        
        //Check if email is valid
        if(validationManager.isValidEmail(email: email!)){
            emailErrLabel.isHidden = true
        }else{
            emailErrLabel.text = "Please enter a valid email"
            emailErrLabel.isHidden = false
            return;
        }
        if(validationManager.isEmailExistAlready(email: email!)){
            emailErrLabel.text = "Email already exist, Please Login"
            emailErrLabel.isHidden = false
            return
        }else{
            emailErrLabel.isHidden = true
        }
        
        //Passwod must be 8 character long
        if(validationManager.isValidPassword(password: password!)){
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
        
        if !(validationManager.isValidPhoneNumber(phone: phone!)){
            phoneErrLabel.isHidden = false
            return;
        }else{
            phoneErrLabel.isHidden = true
        }
        if (validationManager.isValidDate(date: dateTextField.text!)){
            dateErrLabel.isHidden = true
        }else{
            dateErrLabel.isHidden = false
            return;
        }
        

        //Store data
        let isStored = dbManager.createNewUser(fName: fullName!, email: email!, password: password!, phone: phone!, dateOfBirth: dateOfBirth)
        if isStored{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        //On tapping the login
        // Dissmiss itself
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setRadius() {
        let radius = 22 //corner radius value for textfield and button
        
        fNameTextField.layer.cornerRadius = CGFloat(radius)
        emailTextField.layer.cornerRadius = CGFloat(radius)
        passwordTextField.layer.cornerRadius = CGFloat(radius)
        rPasswordTextField.layer.cornerRadius = CGFloat(radius)
        phoneTextField.layer.cornerRadius = CGFloat(radius)
        dateTextField.layer.cornerRadius = CGFloat(radius)
        goButton.layer.cornerRadius = CGFloat(radius)
    }
}

