//
//  Joke.swift
//  ChuckieJokes
//
//  Created by Ляпин Михаил on 21.06.2023.
//

import Foundation
import RealmSwift

class Joke: Object, Codable {
    @Persisted var value: String
    @Persisted var dateLoaded = Date()
    @Persisted var category = List<String>()
    
    enum CodingKeys: String, CodingKey {
        case category = "categories"
        case value
     }
    
    convenience init(categories: [String], value: String) {
        self.init()
        self.category.append(objectsIn: categories)
        self.value = value
    }
}
