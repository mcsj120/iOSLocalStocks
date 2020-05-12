//
//  MappingViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/8/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MappingViewController: UIViewController, MKMapViewDelegate {
    var email: String?
    var location: CLLocation?
    
    @IBOutlet weak var searchItem: UITextField!
    
    @IBOutlet weak var parameter: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

    @IBAction func searchArea(_ sender: Any)
    {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = self.searchItem.text
        request.region = map.region
        let search = MKLocalSearch(request: request)
        map.removeAnnotations(map.annotations)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            var i = 0;
            while i < matchingItems.count
            {
                let placemark = matchingItems[i].placemark
                
                let ani = MKPointAnnotation()
                ani.coordinate = placemark.location!.coordinate
                ani.title = placemark.name
                
                self.map.addAnnotation(ani)
                i += 1;
            }
            
        }
    }
    
    @IBAction func searchPlace(_ sender: Any)
    {
        search()
    }
    
    func search()
    {
        if(searchItem.text?.isEmpty == false)
        {
            CLGeocoder().geocodeAddressString(searchItem.text!, completionHandler:
                {(placemarks, error) in
                    if error != nil
                    {
                        self.searchItem.text = "Bad Location"
                    }
                    else if placemarks!.count > 0 {
                        let placemark = placemarks![0]
                        let span = MKCoordinateSpanMake(0.05, 0.05)
                        let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                        self.map.setRegion(region, animated: true)
                    }
            })
        }
        else
        {
            CLGeocoder().geocodeAddressString("Phoenix", completionHandler:
                {(placemarks, error) in
                    if error != nil
                    {
                        self.searchItem.text = "Bad Location"
                    }
                    else if placemarks!.count > 0 {
                        let placemark = placemarks![0]
                        let span = MKCoordinateSpanMake(0.1, 0.1)
                        let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                        self.map.setRegion(region, animated: true)
                    }
            })
        }
    }
    
    @IBAction func switchSearch(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toStockFromMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let x:searchViewController = segue.destination as? searchViewController
        {
            x.email = email
            if parameter.text?.isEmpty == false
            {
                x.mapparam = parameter.text
            }
        }
        if let x:ProfileViewController = segue.destination as? ProfileViewController
        {
            x.email = email
        }
    }
 
    
    func findCoordinates(completion : @escaping ((Double,Double))->())
    {

        CLGeocoder().reverseGeocodeLocation(location!) { (placemarks, error) in
                if error != nil
                {
                    completion((-10000, -10000))
                }
                else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    let location = placemark.location
                    let coords = location!.coordinate
                    completion((coords.longitude, coords.latitude))
                }
        }
    }

    @IBAction func returnHome(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toHomeFromMap", sender: nil)
    }
    
 
}
