//
//  GoogleServiceInfo.swift
//  Pods
//
//  Created by Kaushal Bisht on 08/03/16.
//
//

import UIKit

public class GoogleGeoModel: NSObject {
    
    public var countryName : String!
    public var postalCode : String!
    public var stateName : String!
    public var cityName : String!
    public var formattedAddress : String!
    
    public init(response:NSDictionary) {
        
        guard let json = response["results"] as? NSArray
            else {return}
        
        guard let data = json.firstObject as? NSDictionary
            else {return}
        
        if let address = data["formatted_address"] as? String {
            formattedAddress = address
        }
        
        guard let addressComponents = data["address_components"] as? NSArray
            else {return}
        
        for object in addressComponents {
            guard let component = object as? NSDictionary
                else {continue}
            
            guard let type = component["types"] as? NSArray
                else {continue}
            
            guard type.count > 0
                else {continue}
            
            if type.containsObject("country") {
                if let country = component["long_name"] as? String {
                    countryName = country
                }
            }
            if type.containsObject("administrative_area_level_1") {
                if let state = component["long_name"] as? String {
                    stateName = state
                }
            }
            if type.containsObject("administrative_area_level_2") {
                if let city = component["long_name"] as? String {
                    cityName = city
                }
            }
            if type.containsObject("postal_code") {
                if let postal = component["long_name"] as? String {
                    postalCode = postal
                }
            }
        }
    }
    
    override public var description : String {
        return "Country Name : \(countryName) | State Name : \(stateName) | City Name : \(cityName) | Postal Code : \(postalCode) | Formatted Address : \(formattedAddress)"
    }
}
