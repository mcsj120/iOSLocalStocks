//
//  CreateViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/8/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit
import SafariServices

class CreateViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var um: UserModel?
    
    
    @IBOutlet weak var apiKeyField: UITextField!
    @IBOutlet weak var confirmPassWordField: UITextField!
    @IBOutlet weak var passWordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func finishProfile(_ sender: Any)
    {
        if((apiKeyField.text?.isEmpty)! || (confirmPassWordField.text?.isEmpty)! || (passWordField.text?.isEmpty)! || (emailField.text?.isEmpty)!)
        {
            print("empty")
            //insert message here about all fields must be filled
        }
        else if(emailField.text?.contains("@") == false)
        {
            print("valid")
            //insert message about valid email
        }
        else if(passWordField.text != confirmPassWordField.text)
        {
            print("match")
            //passwords must match
        }
        else
        {
            let added: Bool = (um?.addRecord(email: emailField.text!, password: passWordField.text!, apikey: apiKeyField.text!))!
            if(added)
            {
                performSegue(withIdentifier: "toHomeFromCreate", sender: nil);
            }
        }
    }
    
    @IBAction func `return`(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toStartFromCreate", sender: nil)
    }
    
    @IBAction func toAlpha(_ sender: Any)
    {
        let urlString = "https://www.alphavantage.co/support/#api-key"
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let des:ProfileViewController = segue.destination as? ProfileViewController
        {
            des.email = emailField.text
            des.apiKey = apiKeyField.text
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        //dismiss(animated: true, completion: nil)
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully == false {
            print("Page did not load!")
            controller.dismiss(animated: true, completion: nil)
        }
    }


}
