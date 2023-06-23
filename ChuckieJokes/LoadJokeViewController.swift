//
//  LoadJokeViewController.swift
//  ChuckieJokes
//
//  Created by Ляпин Михаил on 21.06.2023.
//

import UIKit

class LoadJokeViewController: UIViewController {

    @IBOutlet weak var jokeLabel: UILabel!
    
    @IBOutlet weak var loadJokeButton: UIButton!
    @IBAction func loadRandomJoke(_ sender: Any) {
    
        self.networkService.requestRandomJoke(completion: { [weak self] result in
            switch result {
            case .success(let joke):
                
                DispatchQueue.main.async {
                    self?.jokesRealmService.add(joke: joke)
                    self?.jokeLabel.text = joke.value
                }
    
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self?.presentAlert(message: error.localizedDescription)
                }
            }
            
        })
    }
    
    private let networkService = NetworkService()
    private let jokesRealmService = JokesRealmService()
    
    override func viewDidLoad() {
    
        networkService.requestCategories() { [weak self] in
            DispatchQueue.main.async {
                self?.loadJokeButton.isEnabled = true
            }
        }
        super.viewDidLoad()

    }
}
