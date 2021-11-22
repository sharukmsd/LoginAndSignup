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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<Person>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
//        lblName.text = UserDefaults.standard.string(forKey: "loggedInUserEmail")

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Load data into table view with the help of NSFetchedResultsController
    fileprivate func loadTableFromCoreData() {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "fullName", ascending: true)
        ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            print("Unable to fetch data")
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(fetchedResultsController != nil){
            let persons = fetchedResultsController.fetchedObjects
            return (persons?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person: Person = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = person.fullName
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
            print("Deleted")
            
            context.delete(fetchedResultsController.object(at: indexPath))
            do{
                try context.save()
            }catch{
                print("Error: Could not delete")
            }
            loadTableFromCoreData()
        }
    }

    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        //set key to false
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.set("", forKey: "loggedInUserEmail")
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
}

