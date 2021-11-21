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
    
    var activeTextField : UITextField? = nil
    private var datePicker: UIDatePicker!
    var person: Person?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        person?.fullName = txtFullName.text
        person?.email = txtEmail.text
        person?.password = txtPassword.text
        person?.phone = txtPhone.text
        person?.dateOfBirth = datePicker.date as NSDate
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)

        } catch  {
            print("Error: Could not update")
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
