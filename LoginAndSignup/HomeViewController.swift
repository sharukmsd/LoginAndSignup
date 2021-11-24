//
//  ViewController.swift
//  LoginAndSignup
//
//  Created by Sharuk on 07/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    var loggedInUserEmail: String!
    let dbManager = DatabaseManager()

    var fetchedResultsController: NSFetchedResultsController<Person>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        btnLogout.layer.cornerRadius = CGFloat(7.5)
        myTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

//        lblName.text = UserDefaults.standard.string(forKey: "loggedInUserEmail")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Load data into table view with the help of NSFetchedResultsController
    fileprivate func loadTableFromCoreData() {
        fetchedResultsController = dbManager.getAllUsers()
        reloadTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if(!isUserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self)
            
        }else{
            loadTableFromCoreData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setName()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(fetchedResultsController != nil){
            let persons = fetchedResultsController.fetchedObjects
            return (persons?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let person: Person = fetchedResultsController.object(at: indexPath)
        cell.cellLabel.text = person.fullName
        cell.cellImage.image = UIImage(data: person.image as! Data)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateVC = storyboard?.instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
        updateVC.person = fetchedResultsController.object(at: indexPath)
        self.navigationController?.pushViewController(updateVC, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return `false` if you do not want the
        //  specified item to be editable.
        return true
    }
    
    //deletes cell from table and related data from database
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let personToDelete = self.fetchedResultsController.object(at: indexPath)
            if personToDelete.email == loggedInUserEmail{
                let showErr = UIAlertController(title: "Can't delete", message: "Can't delete logged in user", preferredStyle: UIAlertControllerStyle.alert)
                
                showErr.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                present(showErr, animated: true, completion: { return })
            }
            let confirmDelete = UIAlertController(title: "Confirm deletion", message: "Do you really want to delete \(personToDelete.fullName!)?", preferredStyle: UIAlertControllerStyle.alert)
            
            confirmDelete.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
                (action: UIAlertAction!) in
                
                self.dbManager.deleteUser(userToDelete: personToDelete)
                //reload table
                self.loadTableFromCoreData()
            }))
            
            confirmDelete.addAction(UIAlertAction(title: "No", style: .cancel, handler: {
                (action: UIAlertAction!) in
                
            }))
            present(confirmDelete, animated: true, completion: nil)
        }
    }

    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        //set key to false
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "loggedInUserEmail")
        UserDefaults.standard.synchronize()
        
        // present the login screen
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
    private func reloadTableView(){
        UIView.transition(with: self.myTableView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { () -> Void in
                                    self.myTableView.reloadData()
        },
                                  completion: nil);
    }
    private func setName(){
        loggedInUserEmail = UserDefaults.standard.string(forKey: "loggedInUserEmail")
        let res = dbManager.getUserWithEmail(email: loggedInUserEmail!)
        for person in res{
            lblName.text = (person.value(forKey: "fullName") as! String)
            print(lblName.text!)
        }
    }
}

