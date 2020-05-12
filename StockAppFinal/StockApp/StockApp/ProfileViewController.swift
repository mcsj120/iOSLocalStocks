//
//  ProfileViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/8/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var email:String?
    var apiKey:String?
    var um: UserModel?
    var sm: StockModel?
    var value: Double = 0
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = email!
        um = UserModel()
        sm = StockModel()
        um?.initializeRecords()
        sm?.initializeRecords()
        let temp: [StockEntity] = (sm?.associatedStocks(email: email!))!
        for entry in temp
        {
            value += entry.price
        }
        stockLabel.text = String(value);
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOut(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toMainFromHome", sender: nil)
    }
    
    @IBAction func search(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toSearchFromHome", sender: nil)
    }
    
    @IBAction func cam(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toCameraFromHome", sender: nil)
    }
    
    @IBAction func edit(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toEditFromHome", sender: nil)
    }
    
    @IBAction func watchList(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toWatchListfromHome", sender: nil);
    }
    
    
    
    @IBAction func accessMap(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toMapFromHome", sender: nil);
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let x:navigate = segue.destination as? navigate
        {
            if let y:WatchListViewController = x.viewControllers.first as? WatchListViewController
            {
                y.email = email
                y.seg = "toWatchListfromHome"
            }
        }
        else if let x:searchViewController = segue.destination as? searchViewController
        {
            x.seg = "toSearchFromHome"
            x.email = email
        }
        else if let x:MappingViewController = segue.destination as? MappingViewController
        {
            x.email = email
        }
        else if let x:CameraViewController = segue.destination as? CameraViewController
        {
            x.email = email
        }
        else if let x:helpViewController = segue.destination as? helpViewController
        {
            x.email = email
        }
        else if let x:editProfileViewController = segue.destination as? editProfileViewController
        {
            x.email = email
        }
        
    }
    
    
    
/*
     Asks the user if they really want to delete their profile
     Returns to the start screen if they are sure.
 */
    @IBAction func DeleteProfile(_ sender: Any)
    {
        let alert = UIAlertController(title: "Delete Profile", message: "Are you sure you want to delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let success = self.um?.deleteRecordString(email: self.email!)
            if(success)!
            {
                self.sm?.deleteAllFromEmail(email: self.email!)
                self.performSegue(withIdentifier: "signOutSegue", sender: nil);
            }
            else
            {
                let alert2 = UIAlertController(title: "Deletion failed", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert2, animated: true)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
 
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}
