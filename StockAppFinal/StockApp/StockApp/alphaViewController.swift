//
//  alphaViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/16/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit
import WebKit

class alphaViewController: UIViewController
{
    var webView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView = WKWebView()
        self.view = self.webView!
        /*let scheme = "https"
        let host = "www.alphavantage.co"
        let path = "/support/#api-key"
        
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        // let url = NSURL(string: urlComponents.url )!
        UIApplication.shared.openURL(urlComponents.url!)*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let url = URL(string:"https://www.alphavantage.co/support/#api-key")
        let req = URLRequest(url:url!)
        self.webView!.load(req)
        
    }

    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}

}
