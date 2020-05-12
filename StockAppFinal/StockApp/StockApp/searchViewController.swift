//
//  searchViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/13/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class searchViewController: UIViewController {

    var email:String?
    var sm = StockModel()
    var um = UserModel()
    var seg: String?
    var model = searchListModel()
    var err: String?
    var Iterator: Int = 0
    var prevEntry: String = ""
    var symbolparam: String?
    var nameparam: String?
    var doubleparam: Double?
    var mapparam: String?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var searchItem: UITextField!
    @IBOutlet weak var message: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sm.initializeRecords()
        um.initializeRecords()
        if(mapparam != nil)
        {
            searchItem.text = mapparam
        }
    }
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    
    @IBAction func `return`(_ sender: Any)
    {
        if(seg == nil || seg == "toSearchFromHome")
        {
            self.performSegue(withIdentifier: "toHomeFromStock", sender: nil)
        }
    }
    
    @IBAction func stockSearch(_ sender: Any)
    {
        if(searchItem.text != prevEntry && !(searchItem.text?.isEmpty)!)
        {
            prevEntry = searchItem.text!
            model.searchList.removeAll()
            symbol.text = ""
            name.text = ""
            let retVal = getValue()
            if(retVal)
            {
                Iterator = 0
                display()
            }
            else
            {
                message.text = "Sorry, please try again"
            }
        }
        else
        {
            message.text = "Please enter in a valid value"
        }
    }
    
    @IBAction func addRecord(_ sender: Any)
    {
        if(Iterator <= model.searchList.count - 1 && Iterator >= 0)
        {
            let stock = model.searchList[Iterator]
            symbolparam = stock.Sym
            nameparam = stock.na
            var retVal = addValue()

            if(retVal)
            {
                retVal = sm.addRecord(identifier: email!, name: nameparam!, price: doubleparam!, ticker: symbolparam!)
                if(retVal)
                {
                    message.text = "Success!"
                }
            }
            if(!retVal)
            {
                message.text = "Addition Failed"
            }
            
        }
        else
        {
            message.text = "Please search for a stock"
        }
        
    }
    
    func addValue() -> Bool
    {
        forData
            { result in
                if(result[0] < 0.0)
                {
                    self.doubleparam! = -99
                }
                else
                {
                    self.doubleparam = result[0]
                }
            }
        if(err != "error" && self.doubleparam! >= 0.0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func getData(completion: @escaping ([(String, String)]) -> ())
    {
        var result = [(String, String)]()
        var stock: String = searchItem.text!
        if(stock.contains(" "))
        {
            stock = stock.replacingOccurrences(of: " ", with: "_")
        }
        let api = um.getRecordUnprotected(email: email!)
        let apiKey = api?.apiKey!
        let semaphore = DispatchSemaphore(value: 0)

        let s = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(stock)&apikey=\(apiKey!)"
        
        let url = URL(string: s)
        let task = URLSession.shared.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                result[0].0 = "error"
            }
            else{
                if let content = data{
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        if let match = myJson["bestMatches"] as? NSArray
                        {
                            var iterator = 0
                            while iterator < match.count
                            {
                                let entry = match[iterator] as? [String:AnyObject]
                                let symbol = entry!["1. symbol"]! as! String
                                let name = entry!["2. name"]! as! String
                                if(!(symbol.contains(".")))
                                {
                                    result.append((symbol, name))
                                }
                                iterator = iterator + 1
                            }
                        }
                    }
                    catch {
                        result[0].0 = "error"
                        completion(result)
                        print(error.localizedDescription)
                        semaphore.signal()
                    }
                }
                if(result.isEmpty)
                {
                    result.append(("error","error"))
                }
                completion(result)
                semaphore.signal()
            }
        }
        task.resume()
        semaphore.wait()
    }
    
    func getValue() -> Bool
    {
        getData
            { result in
                if(result.isEmpty || result[0].0 == "error")
                {
                    self.err = "error"
                }
                for item in result
                {
                    self.model.addRecord(a: item.0, b: item.1)
                }
        }
        if(err != "error")
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    @IBAction func prev(_ sender: Any)
    {
        Iterator = Iterator - 1
        display()
    }
    
    @IBAction func next(_ sender: Any)
    {
        Iterator = Iterator + 1
        display()
    }
    
    
    
    func display()
    {

        if(Iterator < 0)
        {
            message.text = "Beginning of list"
            Iterator = 0
        }
        else if(Iterator >= model.searchList.count)
        {
            message.text = "End of List"
            Iterator = model.searchList.count - 1
        }
        else
        {
            let x: searchInfo = model.getEq(index: Iterator)
            symbol.text = x.Sym
            name.text = x.na
            message.text = ""
        }
    }
    
    
    func forData(completion: @escaping ([Double]) -> ())
    {
        var result = [Double]()
        let api = um.getRecordUnprotected(email: email!)
        let apiKey = api?.apiKey
        let stock = symbolparam
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
                if(result.isEmpty == false)
                {
                    completion(result)
                    semaphore.signal()
                }
            }
        }
        task.resume()
        semaphore.wait()
        
    }
    
    @IBAction func back(_ sender: Any)
    {
        if(seg == nil || seg! == "toSearchFromHome")
        {
            self.performSegue(withIdentifier: "toHomeFromSearch", sender: nil)
        }
    }
    
    @IBAction func transfer(_ sender: Any)
    {
        var valid = true;
        valid = !(model.searchList.isEmpty) && !((symbol.text?.isEmpty)!)
        if(valid)
        {
            let stock = model.searchList[Iterator]
            
            symbolparam = stock.Sym
            nameparam = stock.na
            addValue()

            sm.addRecord(identifier: "", name: nameparam!, price: doubleparam!, ticker: symbolparam!)
            performSegue(withIdentifier: "toStock2FromSearch", sender: nil)
        }
        else
        {
            message.text = "Stock/Price not found"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if let viewController:ProfileViewController = segue.destination as? ProfileViewController
        {
            viewController.email = email
        }
        else if let vc:StockViewController2 = segue.destination as? StockViewController2
        {
            vc.email = email
        }
    }
    
    
}
