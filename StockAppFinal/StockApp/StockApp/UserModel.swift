//
//  UserModel.swift
//  StockApp
//
//  Created by mcstonge on 11/8/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//
import UIKit
import CoreData
import Foundation

public class UserModel
{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchResults = [UserEntity]()
    
    func initializeRecords() -> Int
    {
        // Create a new fetch request using the UserEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        // Execute the fetch request, and cast the results to an array of CityEnity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [UserEntity])!
        
        let x = fetchResults.count
        
        return x
    }
    
    func addRecord(email: String, password: String, apikey:String) -> Bool
    {
        for entry in fetchResults
        {
            if entry.email! == email || entry.password! == password || entry.apiKey! == apikey
            {
                return false
            }
        }
        
        // create a new entity object
        let ent = NSEntityDescription.entity(forEntityName: "UserEntity", in: self.managedObjectContext)
        //add to the manege object context
        let newItem = UserEntity(entity: ent!, insertInto: self.managedObjectContext)
        newItem.email = email
        newItem.password = password
        newItem.apiKey = apikey
        
        // save the updated context
        do {
            try self.managedObjectContext.save()
        } catch _ {
            return false
        }

        return true
    }
    
    func getRecord(email: String, password: String) -> UserEntity?
    {
        for entry in fetchResults
        {
            if entry.email! == email && entry.password! == password
            {
                return entry
            }
        }
        return nil
    }
    
    func getRecordUnprotected(email: String) -> UserEntity?
    {
        for entry in fetchResults
        {
            if entry.email! == email
            {
                return entry
            }
        }
        return nil
    }
    
    func foundRecord(email: String, password: String) ->Bool
    {
        if getRecord(email: email, password: password) != nil
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func foundRecordUnprotected(email: String) ->Bool
    {
        if getRecordUnprotected(email: email) != nil
        {
            return true
        }
        else
        {
            return false
        }
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
        if(fetchResults.count == 0)
        {
            var s = StockModel()
            s.initializeRecords()
            s.deleteAll();
        }
        return true
    }
    
    func deleteRecordString(email: String) -> Bool
    {
        var iterator = 0
        for results in fetchResults
        {
            if(results.email == email)
            {
                let x = deleteRecordInt(row: iterator)
                return x
            }
            iterator = iterator + 1;
        }
        return false
    }
    
    func changePassword(email: String, password: String)
    {
        if foundRecordUnprotected(email: email)
        {
            let x: UserEntity = getRecordUnprotected(email: email)!
            let name = x.email
            let password = password
            let apikey = x.apiKey
            managedObjectContext.delete(x)
            // remove it from the fetch results array
            fetchResults.remove(at: fetchResults.index(of: x)!)
            
            do {
                // save the updated managed object context
                try managedObjectContext.save()
                
            } catch {
                return
            }
            addRecord(email: name!, password: password, apikey: apikey!)
            initializeRecords()
        }
    }
    
    func changeAPI(email:String, api: String)
    {
        if foundRecordUnprotected(email: email)
        {
            let x: UserEntity = getRecordUnprotected(email: email)!
            let name = x.email
            let password = x.password
            let apikey = api
            managedObjectContext.delete(x)
            // remove it from the fetch results array
            fetchResults.remove(at: fetchResults.index(of: x)!)
            
            do {
                // save the updated managed object context
                try managedObjectContext.save()
                
            } catch {
                return
            }
            addRecord(email: name!, password: password!, apikey: apikey)
            initializeRecords()
        }
    }
    
}
