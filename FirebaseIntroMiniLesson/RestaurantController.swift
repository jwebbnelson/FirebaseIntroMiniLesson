//
//  RestaurantController.swift
//  FirebaseIntroMiniLesson
//
//  Created by Jordan Nelson on 2/29/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import Firebase

public let RestaurantsUpdatedNotification = "RestaurantsUpdatedNotificationName"

class RestaurantController {
    
    static let sharedController = RestaurantController()
    
    var restaurants:[Restaurant] {
        didSet {
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(RestaurantsUpdatedNotification, object: self)
        }
    }
    
    init() {
        self.restaurants = []
        loadRestaurants()
    }
    
    func loadRestaurants() {
        
        FirebaseController.restaurantsRef.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            
            for restaurantDictionary in snapshot.children {
                if let restaurantSnap = restaurantDictionary as? FDataSnapshot, let unwrappedRestaurant = restaurantSnap.value as? [String: AnyObject] {
                    if let restaurant = Restaurant(dictionary: unwrappedRestaurant) {
                        self.restaurants.append(restaurant)
                    }
                }
            }
        })
    }
    
    
    func addRestaurant(restaurant:Restaurant) {
        
        let newRestaurantRef = FirebaseController.restaurantsRef.childByAutoId()
        newRestaurantRef.setValue(restaurant.dictionaryCopy())
    }
    
    
}



