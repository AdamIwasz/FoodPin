//
//  Restaurant.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 18/09/2022.
//

import Foundation

struct Restaurant: Hashable{
    
    var name: String = ""
    var type: String = ""
    var location: String = ""
    var phone: String = ""
    var description: String = ""
    var image: String = ""
    var isFavorite: Bool = false
}
