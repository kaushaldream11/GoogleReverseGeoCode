//
//  ViewController.swift
//  GoogleReverseGeoCode
//
//  Created by ”kaushaldream11” on 03/08/2016.
//  Copyright (c) 2016 ”kaushaldream11”. All rights reserved.
//

import UIKit
import GoogleReverseGeoCode
import CoreLocation


class ViewController: UIViewController {
    
    
    let geoCode = GoogleGeoCodeService()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoCode.locationPermissionClosure = {(status: CLAuthorizationStatus) in
            print(status)
        }
        
        geoCode.locationErrorClosure = {(status: CLAuthorizationStatus, error: NSError) in
            print("Status : \(status) | Error : \(error)")
        }
        
        geoCode.getCurrentLocationGeo { (obj:GoogleGeoModel?, error:NSError?) -> Void in
            guard error == nil
                else {return}
            
            print(obj)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

