//
//  navigate.swift
//  StockApp
//
//  Created by mcstonge on 11/13/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit

class navigate: UINavigationController
{
    var email:String?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let x:WatchListViewController = segue.destination as? WatchListViewController
        {
            x.email = email
        }
    }
}
