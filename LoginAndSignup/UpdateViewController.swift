//
//  UpdateViewController.swift
//  LoginAndSignup
//
//  Created by Sharuk on 21/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import UIKit
import CoreData

class UpdateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var fNameErrLabel: UILabel!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var passErrLabel: UILabel!
    @IBOutlet weak var phoneErrLabel: UILabel!
    @IBOutlet weak var dateErrLabel: UILabel!
    
    var activeTextField : UITextField? = nil
    private var datePicker: UIDatePicker!
    var person: Person?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let validationManager = ValidationManager()

    fileprivate func setDelegates() {
        txtFullName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtPassword.delegate = self
        txtPhone.delegate = self
        txtDateOfBirth.delegate = self
    }
    fileprivate func setUpDatePicker() {
        //Date Picker initialization
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        txtDateOfBirth.inputView = datePicker
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeHideKeyboard()
        
        setDelegates()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        setUpDatePicker()
        
        txtFullName.text = person?.fullName
        txtEmail.text = person?.email
        txtPassword.text = person?.password
        txtPhone.text = person?.phone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        txtDateOfBirth.text = dateFormatter.string(from: person?.dateOfBirth as! Date)
        // Do any additional setup after loading the view.
    }
    func initializeHideKeyboard() {
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
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
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        txtDateOfBirth.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func updateTapped(_ sender: Any) {
        let fullName = txtFullName.text
        let email = txtEmail.text
        let password = txtPassword.text
        let phone = txtPhone.text
        let dateOfBirth = datePicker.date as NSDate
        
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
        
        //Passwod must be 8 character long
        if(validationManager.isValidPassword(password: password!)){
            passErrLabel.isHidden = true
        }else{
            passErrLabel.isHidden = false
            return;
        }
        
        if !(validationManager.isValidPhoneNumber(phone: phone!)){
            phoneErrLabel.isHidden = false
            return;
        }else{
            phoneErrLabel.isHidden = true
        }
        if (validationManager.isValidDate(date: txtDateOfBirth.text!)){
            dateErrLabel.isHidden = true
        }else{
            dateErrLabel.isHidden = false
            return;
        }
        
        
        person?.fullName = fullName
        person?.email = email
        person?.password = password
        person?.phone = phone
        person?.dateOfBirth = dateOfBirth
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)

        } catch  {
            print("Error: Could not update")
        }
        
    }

}
