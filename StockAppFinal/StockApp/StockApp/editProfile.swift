//
//  editProfile.swift
//  StockApp
//
//  Created by mcstonge on 11/16/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class editProfileViewController: UIViewController
{
    @IBOutlet weak var choice: UISegmentedControl!
    @IBOutlet weak var change: UITextField!
    
    var email: String?
    var um: UserModel = UserModel()
    var sm: StockModel = StockModel()
    var User: UserEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sm.initializeRecords()
        um.initializeRecords()
        User = (um.getRecordUnprotected(email: email!))!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func changeButton(_ sender: Any)
    {
        if (change.text?.isEmpty)!
        {
            let alert = UIAlertController(title: "Nothing Changed", message: "Text Field is empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else if choice.selectedSegmentIndex == 0
        {
            if User?.password != change.text
            {
                um.changePassword(email: email!, password: change.text!)
                let alert = UIAlertController(title: "Password Changed", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "toHomeFromEdit", sender: nil)
                }))
                self.present(alert, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Password Not Changed", message: "The password is the same as the previous password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else if choice.selectedSegmentIndex == 1
        {
            if User?.apiKey != change.text
            {
                um.changeAPI(email: email!, api: change.text!)
                let alert = UIAlertController(title: "API Key Changed", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "toHomeFromEdit", sender: nil)
                }))
                self.present(alert, animated: true)

            }
            else
            {
                let alert = UIAlertController(title: "API-Key Not Changed", message: "The API-key is the same as the previous API-key", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func ret(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toHomeFromEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let x:ProfileViewController = segue.destination as? ProfileViewController
        {
            x.email = email
        }
    }
    
    
}
