//
//  StockViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/8/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class StockViewController: UIViewController {

    var stock: StockEntity?
    var email: String?
    var sm = StockModel()
    var um = UserModel()
    var doubleparam = 0.0
    var err: String?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ticker.text! = (stock?.ticker)!
        name.text! = (stock?.name)!
        um.initializeRecords()
        sm.initializeRecords()
        addValue()
        if(addValue())
        {
            sm.editStockValue(ticker: email!, price: doubleparam)
            price.text = String(doubleparam)
        }
        else{
            price.text = String(stock!.price)
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let x:WatchListViewController = segue.destination as? WatchListViewController
        {
            x.email = email
        }
    }

    @IBAction func returnTable(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toTableFromStock", sender: nil)
    }
    
    @IBAction func removeStock(_ sender: Any)
    {
        let alert = UIAlertController(title: "Delete Stock?", message: "Would you like to remove this stock from your List?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.sm.initializeRecords()
            self.sm.deleteRecordEntity(entity: self.stock!)
            self.performSegue(withIdentifier: "toTableFromStock", sender: nil)
            }))
        
        
        self.present(alert, animated: true)
    }
    
    func addValue() -> Bool
    {
        forData
            { result in
                if(result[0] < 0.0)
                {
                    self.doubleparam = -99
                }
                else
                {
                    self.doubleparam = result[0]
                }
        }
        if(self.doubleparam >= 0.0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func forData(completion: @escaping ([Double]) -> ())
    {
        var result = [Double]()
        let api = um.getRecordUnprotected(email: email!)
        let apiKey = api?.apiKey
        let stock = self.stock?.ticker
        let semaphore = DispatchSemaphore(value: 0)
        
        let s = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(stock!)&interval=1min&apikey=\(apiKey!)"
        let url = URL(string: s)
        let task = URLSession.shared.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                result.append(-999.0)
            }
            else{
                if let content = data{
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        print(myJson)
                        if let time = myJson["Time Series (1min)"] as? NSDictionary
                        {
                            var arr = [String]()
                            for entry in time.allKeys
                            {
                                arr.append(entry as! String)
                            }
                            arr.sort()
                            if let value = time[arr[arr.count-1]] as? [String:AnyObject]
                            {
                                if let price = value["1. open"] as? String
                                {
                                    result.append(Double(price)!)
                                }
                            }
                            
                            //result.append((x["1. open"] as? Double)!)
                            //self.sm.addRecord(identifier: self.email!, name: self.nameparam!, price: price, ticker: stock!)
                        }
                    }
                    catch {
                        result.append(-999.9)
                        completion(result)
                        print(error.localizedDescription)
                        semaphore.signal()
                    }
                }
                if(result.isEmpty)
                {
                    result.append(-999.9)
                }
                completion(result)
                semaphore.signal()
            }
        }
        task.resume()
        semaphore.wait()
        
    }
}
