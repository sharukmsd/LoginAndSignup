//
//  ViewController.swift
//  LoginAndSignup
//
//  Created by Sharuk on 07/11/2021.
//  Copyright © 2021 Programmers force. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        print(isUserLoggedIn)
        if(!isUserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        //set key to false
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        // present the login screen
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
}

