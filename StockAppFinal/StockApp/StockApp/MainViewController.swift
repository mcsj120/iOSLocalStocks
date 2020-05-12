//
//  ViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/8/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!{
        didSet {
            image.clipsToBounds = true
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    var um: UserModel?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        um = UserModel()
        um!.initializeRecords()
        self.image.image = UIImage(named: "stock.jpg")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let _:AboutViewController = segue.destination as? AboutViewController
        {
            
        }
        else if let cvc:CreateViewController = segue.destination as? CreateViewController
        {
            cvc.um = um
        }
        else if let lvc:LoginViewController = segue.destination as? LoginViewController
        {
            lvc.um = um
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue)
    {
        if let _ = segue.source as? AboutViewController
        {
            
        }
        else if let _ = segue.source as? CreateViewController
        {
            
        }
        else if let _ = segue.source as? LoginViewController
        {
            
        }
        else if let _ = segue.source as? ProfileViewController
        {
            
        }
    }


}

