//
//  searchListModel.swift
//  StockApp
//
//  Created by mcstonge on 11/13/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import Foundation

class searchListModel
{
    var searchList = [searchInfo]()
    init()
    {
        
    }
    
    func addRecord(a:String, b:String)
    {
        let x = searchInfo(symbol: a, name: b)
        searchList.append(x)
    }
    
    func getEq(index: Int) -> searchInfo
    {
        return searchList[index];
    }
}

class searchInfo
{
    let Sym: String
    let na: String
    init(symbol: String, name: String)
    {
        Sym = symbol
        na = name
    }
}
