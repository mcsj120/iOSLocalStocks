//
//  WatchListViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/8/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class WatchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var stockTable: UITableView!
    var email: String?
    var sm = StockModel()
    var um = UserModel()
    var seg: String?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(email != nil)
        {
            sm.initializeRecords()
            um.initializeRecords()
            let stocks = sm.associatedStocks(email: email!)
            return stocks.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // add each row from coredata fetch results
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! stockTableView
        cell.layer.borderWidth = 1.0
        
        let stocks = sm.associatedStocks(email: email!)
        let rowdata = stocks[indexPath.row]
        
        cell.Name.text = rowdata.name
        cell.Price.text = String(rowdata.price)
    
        
        return cell
    }
    
    // delete table entry
    // this method makes each row editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool    {        return true    }
    // return the table view style as deletable
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle { return UITableViewCellEditingStyle.delete }
    
    
    // implement delete function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            sm.deleteRecordInt(row: indexPath.row)
            // reload the table after deleting a row
            stockTable.reloadData()
        }
    }

    @IBAction func trashStock(_ sender: Any)
    {
        let alert = UIAlertController(title: "Delete Stock", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler:
            {
                textField in textField.placeholder = "Enter Stock Name"
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text
            {
                self.sm.deleteRecordString(ticker: name)
                self.stockTable.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        sm.initializeRecords()
        um.initializeRecords()
        self.stockTable.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchSeg(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toSearchFromWatchList", sender: nil)
    }
    
    @IBAction func back(_ sender: Any)
    {
        if(seg == nil || seg! == "toWatchListfromHome")
        {
            self.performSegue(withIdentifier: "toHomeFromWatch", sender: nil)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {

        if let viewController:StockViewController = segue.destination as? StockViewController
        {
            let selectedIndex: IndexPath = self.stockTable.indexPath(for: sender as! UITableViewCell)!
            
            let stock = sm.getRecord(index: selectedIndex.row)
            viewController.stock = stock
            viewController.email = email
        }
        else if let viewController:ProfileViewController = segue.destination as? ProfileViewController
        {
            viewController.email = email
        }
        else if let vc:searchViewController = segue.destination as? searchViewController
        {
            vc.email = email
        }

    }
    


}
