//
//  LoginViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/8/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var um: UserModel?
    var apiKey:String?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any)
    {
        if((usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)!)
        {
            //display error that it must have stuff
        }
        else
        {
            let found: Bool = (um?.foundRecord(email: usernameField.text!, password: passwordField.text!))!
            if(found)
            {
                let thisUser: UserEntity = (um?.getRecord(email: usernameField.text!, password: passwordField.text!))!
                apiKey = thisUser.apiKey
                performSegue(withIdentifier: "toHomeFromLogin", sender: nil);
            }
            else
            {
                let alert = UIAlertController(title: "Invalid Password", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let des:ProfileViewController = segue.destination as? ProfileViewController
        {
            des.email = usernameField.text
            des.apiKey = apiKey
        }
    }


}
