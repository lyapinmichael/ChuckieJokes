//
//  RealmService.swift
//  ChuckieJokes
//
//  Created by Ляпин Михаил on 20.06.2023.
//

import Foundation
import RealmSwift

final class JokesRealmService {
    
    private var _jokes: [Joke] = []
    var jokes: [Joke] {
        get {
            return _jokes.sorted(by: {$0.dateLoaded > $1.dateLoaded})
        }
        set {
            _jokes = newValue
        }
    }
    
    init() {
         fetchJokes()
    }
    
    func fetchJokes() {
        let realm = try! Realm()
        jokes = realm.objects(Joke.self).map{$0}
    }
    
     func add(joke: Joke) {
         let realm = try! Realm()
         
         guard !jokes.contains(where: {$0 == joke}) else { return }
         try! realm.write({
             realm.add(joke)
         })
         fetchJokes()
    }
    
    
    func deleteJoke(atIndex index: Int) {
        let realm = try! Realm()
        try! realm.write{
            realm.delete(jokes[index])
        }
        fetchJokes()
    }
}

struct Categories {
    typealias LoadedCategories = [String]
    
    static var shared = LoadedCategories()
}
