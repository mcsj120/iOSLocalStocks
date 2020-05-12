//
//  StockModel.swift
//  StockApp
//
//  Created by mcstonge on 11/13/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit
import CoreData
import Foundation

public class StockModel
{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchResults = [StockEntity]()

    func initializeRecords() -> Int
    {
        // Create a new fetch request using the UserEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StockEntity")
        // Execute the fetch request, and cast the results to an array of CityEnity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [StockEntity])!
        
        let x = fetchResults.count
        
        return x
    }
    
    func associatedStocks(email: String) ->[StockEntity]
    {
        var stocks = [StockEntity]()
        for entry in fetchResults
        {
            if(entry.identifier == email)
            {
                print(entry.identifier)
                stocks.append(entry)
            }
        }
        return stocks;
    }
    
    func addRecord(identifier: String, name: String, price:Double, ticker:String ) -> Bool
    {

        var iterator = 0
        for entry in fetchResults
        {
            if (entry.name! == name || entry.ticker! == ticker) && entry.identifier == identifier
            {
                deleteRecordInt(row: iterator)
            }
            iterator += 1
        }

        
        // create a new entity object
        let ent = NSEntityDescription.entity(forEntityName: "StockEntity", in: self.managedObjectContext)
        //add to the manege object context
        let newItem = StockEntity(entity: ent!, insertInto: self.managedObjectContext)
        newItem.identifier = identifier
        newItem.name = name
        newItem.price = price
        newItem.ticker = ticker
        
        // save the updated context
        do {
            try self.managedObjectContext.save()
        } catch _ {
            return false
        }
        
        return true
    }
    
    func deleteRecordInt(row:Int) -> Bool
    {
        managedObjectContext.delete(fetchResults[row])
        // remove it from the fetch results array
        fetchResults.remove(at:row)
        
        do {
            // save the updated managed object context
            try managedObjectContext.save()
        } catch {
            return false
        }
        initializeRecords()
        return true
    }
    func deleteAllFromEmail(email: String)
    {
        var i = fetchResults.count - 1
        while i >= 0
        {
            if fetchResults[i].name == email
            {
                deleteRecordInt(row: i)
            }
            i = i - 1
        }
        initializeRecords()
    }
    
    func deleteRecordString(ticker: String) -> Bool
    {
        var iterator = 0
        for results in fetchResults
        {
            if(results.ticker == ticker  || results.name == ticker)
            {
                let x = deleteRecordInt(row: iterator)
                return x
            }
            iterator = iterator + 1;
        }
        return false
    }
    
    func deleteRecordEntity(entity: StockEntity) -> Bool
    {
        let ticker = entity.ticker
        var iterator = 0
        managedObjectContext.delete(entity)
        for entry in fetchResults
        {
            if entry.ticker == ticker
            {
                fetchResults.remove(at: iterator)
            }
            iterator += 1
        }
        
        do {
            // save the updated managed object context
            try managedObjectContext.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func getRecord(index: Int) -> StockEntity?
    {
        return fetchResults[index]
    }
    
    func editLast(email: String)
    {
        if(fetchResults.count > 0)
        {
            let email = email
            let name = fetchResults.last?.name
            let ticker = fetchResults.last?.ticker
            let price = fetchResults.last?.price
            deleteRecordInt(row: fetchResults.count - 1)
            do {
                // save the updated managed object context
                try managedObjectContext.save()

            } catch {
                                return
            }
            addRecord(identifier: email, name: name!, price: price!, ticker: ticker!)
            initializeRecords()
        }
    }
    
    func editStockValue(ticker: String, price: Double)
    {
        var iterator = 0
        for entry in fetchResults
        {
            if entry.ticker == ticker
            {
                let ticker = entry.ticker
                let name = entry.name
                let price = price
                let identifier = entry.identifier
                deleteRecordInt(row: iterator)
                fetchResults.remove(at: iterator)
                addRecord(identifier: identifier!, name: name!, price: price, ticker: ticker!)
            }
            iterator += 1
        }
    }
    
    func deleteAll()
    {
        while fetchResults.count > 0
        {
            deleteRecordInt(row: 0)
        }
    }
    
}
