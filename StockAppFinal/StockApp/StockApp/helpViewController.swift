//
//  helpViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/14/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class helpViewController:UIViewController
{
    @IBOutlet weak var text: UITextView!
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    @IBAction func back(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toHomeFromHelp", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let x:ProfileViewController = segue.destination as? ProfileViewController
        {
            x.email = email;
        }
    }
}
