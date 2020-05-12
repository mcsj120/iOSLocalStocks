//
//  stockViewController2.swift
//  StockApp
//
//  Created by mcstonge on 11/14/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class StockViewController2: UIViewController {
    
    var stock: StockEntity?
    var email: String?
    var sm = StockModel()
    var um = UserModel()
    var added = false
    var size: Int?
    
    @IBOutlet weak var tick: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        size = sm.initializeRecords()
        um.initializeRecords()
        stock = sm.getRecord(index: size! - 1)
        tick.text! = (stock?.ticker)!
        name.text! = (stock?.name)!
        price.text = String(stock!.price)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func addToList(_ sender: Any)
    {
        let arr : [StockEntity] = sm.associatedStocks(email: email!)
        let last = sm.fetchResults.last
        var add = true
        for entry in arr
        {
            if last?.ticker==entry.ticker || last?.name == entry.name
            {
                add = false
            }
        }
        if(add)
        {
            sm.editLast(email: email!)
            let alert = UIAlertController(title: "Stock Added!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        if(!add)
        {
            let alert = UIAlertController(title: "Stock not added", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                //self.performSegue(withIdentifier: "toHomeFromEdit", sender: nil)
            }))
            self.present(alert, animated: true)
        }
        added = true
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
        if let x:searchViewController = segue.destination as? searchViewController
        {
            x.email = email
        }
     }

    @IBAction func returning(_ sender: Any)
    {
        if(!added)
        {
            sm.deleteRecordInt(row: size! - 1)
        }
        performSegue(withIdentifier: "toSearchFromStock2", sender: nil)
    }
    
}
