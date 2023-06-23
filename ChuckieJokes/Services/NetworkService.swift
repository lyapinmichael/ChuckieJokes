//
//  NetworkService.swift
//  ChuckieJokes
//
//  Created by Ляпин Михаил on 20.06.2023.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badResponse
    case statsusCodeNot200
    case dataNil
    case failedToSerializeData
}

final class NetworkService {
    
    private var urlSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    func requestRandomJoke(completion: @escaping ((Result<Joke, Error>) -> Void)) {
        
        guard let category = Categories.shared.randomElement() else {
            assertionFailure("Trying to get random category before getting list of all categories from API")
            return
        }
        
        guard let url = URL(string: "https://api.chucknorris.io/jokes/random?category=\(category)") else {
            assertionFailure("Bad URL")
            return
        }
        
        dataTask = urlSession.dataTask(with: url) { [weak self] data, response, error in
            if let error {
                completion(.failure(error))
                self?.dataTask = nil
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.badResponse))
                self?.dataTask = nil
                return
            }
            
            guard response.statusCode == 200 else {
                completion(.failure(NetworkError.statsusCodeNot200))
                self?.dataTask = nil
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.dataNil))
                self?.dataTask = nil
                return
            }
            
            do {
                let joke = try JSONDecoder().decode(Joke.self, from: data)
                completion(.success(joke))
            } catch {
                completion(.failure(error))
                print("Не парсится джейсон!!!")
            }
        }
        dataTask?.resume()
    }
    
    func requestCategories(completion: @escaping (() -> Void)) {
        guard let url = URL(string: "https://api.chucknorris.io/jokes/categories") else {
            assertionFailure("Bad URL")
            return
        }
        
        dataTask = urlSession.dataTask(with: url) { [weak self] data, response, error in
            if let error {
                print(error.localizedDescription)
                self?.dataTask = nil
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print(error?.localizedDescription ?? "Bad response")
                self?.dataTask = nil
                return
            }
            
            guard response.statusCode == 200 else {
                print(error?.localizedDescription ?? "Status code not 200")
                self?.dataTask = nil
                return
            }
            
            guard let data else {
                print(error?.localizedDescription ?? "Data nil")
                self?.dataTask = nil
                return
            }
            
            do {
                let serializedData = try JSONDecoder().decode(Categories.LoadedCategories.self, from: data)
                Categories.shared = serializedData
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask?.resume()
    }
}
