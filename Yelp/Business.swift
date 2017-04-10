//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import ObjectMapper

class Business: Mappable {
    var categories: [[String]]?
    var categoriesString: String?
    var displayPhone: String?
    var location: NSDictionary?
    var addressString: String?
    var distance: Float?
    var distanceMiles: String?
    var id: String?
    var imageURL: URL?
    var isClaimed: Bool?
    var isClose: Bool?
    var address: String?
    var coordinate: [String]?
    var menuDateUpdated: Date?
    var menuProvider: String?
    var mobileURL: URL?
    var name: String?
    var phone: Int?
    var rating: String?
    var ratingImgURL: URL?
    var ratingImgURLLarge: URL?
    var ratingImgURLSmall: URL?
    var reviewCount: Int?
    var snippetImageURL: URL?
    var snippetText: String?
    var url: URL?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        categories         <- map["categories"]
        displayPhone       <- map["display_phone"]
        distance           <- map["distance"]
        location           <- map["location"]
        id                 <- map["id"]
        imageURL           <- (map["image_url"], URLTransform())
        isClaimed          <- map["is_claimed"]
        isClose            <- map["is_closed"]
        menuDateUpdated    <- (map["menu_date_updated"], DateTransform())
        menuProvider       <- map["menu_provider"]
        mobileURL          <- (map["mobile_url"], URLTransform())
        name               <- map["name"]
        phone              <- map["phone"]
        rating             <- map["rating"]
        ratingImgURL       <- (map["rating_img_url"], URLTransform())
        ratingImgURLLarge  <- (map["rating_img_url_large"], URLTransform())
        ratingImgURLSmall  <- (map["rating_img_url_small"], URLTransform())
        reviewCount        <- map["review_count"]
        snippetImageURL    <- (map["snipped_image_url"], URLTransform())
        snippetText        <- map["snippet_text"]
        url                <- (map["url"], URLTransform())
        
        setCategoryString(categoriesArray: categories)
        setDistance(distanceMeters: distance)
        setAddressString(locationDictionary: location)
    }

    
    func setCategoryString(categoriesArray: [[String]]?) {
        var categoryString = ""

        if let categoriesArray = categoriesArray {
            var categoryNames = [String]()
            for category in categoriesArray {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categoryString = categoryNames.joined(separator: ", ")
        } else {
            categoryString = ""
        }

        self.categoriesString = categoryString
    }
    
    func setDistance(distanceMeters: Float?) {
        if let distanceMeters = distanceMeters {
            let milesPerMeter = 0.000621371
            distanceMiles = String(format: "%.2f mi", milesPerMeter * Double(distanceMeters))
        } else {
            distanceMiles = ""
        }
    }
    
    func setAddressString(locationDictionary: NSDictionary?) {
        var address = ""
        if let locationDictionary = locationDictionary {
            let addressArray = locationDictionary["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = locationDictionary["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        addressString = address
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses: [Business] = []
        for dictionary in array {
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: dictionary,
                options: []) {
                let jsonString = String(data: theJSONData,
                                         encoding: .ascii)
                
                let business = Business(JSONString: jsonString!)
                businesses.append(business!)
            }
            
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, radius: Int?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, radius: radius, completion: completion)
    }
}
