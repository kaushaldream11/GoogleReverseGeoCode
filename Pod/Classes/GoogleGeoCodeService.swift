//
//  GoogleGeoCodeService.swift
//  Pods
//
//  Created by Kaushal Bisht on 08/03/16.
//
//

import UIKit
import CoreLocation

public class GoogleGeoCodeService :NSObject, CLLocationManagerDelegate{
    
    var locationManager:CLLocationManager!
    public var locationPermissionClosure:((CLAuthorizationStatus) -> (Void))?
    public var locationErrorClosure:((CLAuthorizationStatus, NSError) -> (Void))?
    internal var completionClosure : ((GoogleGeoModel?, NSError?) -> Void)?
    
    required public override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func getLocationFromCoordinate(coordinate:CLLocationCoordinate2D, onCompletion: ((GoogleGeoModel?, NSError?) -> Void)?) {
        
        if (onCompletion != nil)
        {
            completionClosure = onCompletion
        }
        
        print(coordinate.latitude)
        print(coordinate.longitude)
        
        let urlPath: String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinate.latitude),\(coordinate.longitude)"
        print(urlPath)
        let url = NSURL(string: urlPath)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard error == nil
                else {
                    self.completionClosure!(nil , error)
                    self.completionClosure = nil
                    return
            }
            
            do {
                let json =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                let object = GoogleGeoModel(response: json as! NSDictionary)
                self.completionClosure!(object , nil)
                self.completionClosure = nil
            } catch {
                
            }
        }
        task.resume()
    }
    
    public func getCurrentLocationGeo(completion: ((GoogleGeoModel?, NSError?) -> Void)?) {
        completionClosure = completion
        
        if CLLocationManager.authorizationStatus() == .NotDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .AuthorizedAlways || CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
        }
        else
        {
            locationPermissionClosure!(CLLocationManager.authorizationStatus())
        }
    }
    
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
        }
        
        locationPermissionClosure!(status)
    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationErrorClosure!(CLLocationManager.authorizationStatus(), error)
        }
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        guard let location = locations.first
            else {return}
        
        locationManager.stopUpdatingLocation()
        let latitude :CLLocationDegrees = location.coordinate.latitude
        let longitude :CLLocationDegrees = location.coordinate.longitude
        
        let currentlocation = CLLocationCoordinate2DMake(latitude, longitude)
        self.getLocationFromCoordinate(currentlocation, onCompletion: nil)
    }
}