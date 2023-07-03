//
//  RealmService.swift
//  ChuckieJokes
//
//  Created by Ляпин Михаил on 20.06.2023.
//

import Foundation
import RealmSwift

final class JokesRealmService {
    
    static var shared = JokesRealmService()
    
    private var _jokes: [Joke] = []
    var jokes: [Joke] {
        get {
            return _jokes.sorted(by: {$0.dateLoaded > $1.dateLoaded})
        }
        set {
            _jokes = newValue
        }
    }
    
    private init() {
        
        fetchJokes()
        
    }
    
    func fetchJokes() {
        let configuration = Realm.Configuration(encryptionKey: getKey())
        let realm = try! Realm(configuration: configuration)
        
        jokes = realm.objects(Joke.self).map{$0}
    }
    
     func add(joke: Joke) {
         guard !jokes.contains(where: {$0 == joke}) else { return }
         
         let configuration = Realm.Configuration(encryptionKey: getKey())
         let realm = try! Realm(configuration: configuration)

         try! realm.write({
             realm.add(joke)
         })
         fetchJokes()
    }
    
    
    func deleteJoke(atIndex index: Int) {
        let configuration = Realm.Configuration(encryptionKey: getKey())
        let realm = try! Realm(configuration: configuration)

        try! realm.write{
            realm.delete(jokes[index])
        }
        fetchJokes()
    }
    
    private func getKey() -> Data {
        
        let keychainIdentifier = "Jokes.Realm.EncryptionKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            
            return dataTypeRef as! Data
        }
        
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })
        
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        return key
    }
}

struct Categories {
    typealias LoadedCategories = [String]
    
    static var shared = LoadedCategories()
}
