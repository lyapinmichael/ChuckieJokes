//
//  AllJokesTableController.swift
//  ChuckieJokes
//
//  Created by Ляпин Михаил on 22.06.2023.
//

import UIKit

class AllJokesTableController: UITableViewController {

    private var jokesRealmService = JokesRealmService()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        jokesRealmService.fetchJokes()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jokesRealmService.jokes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        let joke = jokesRealmService.jokes[indexPath.row]
        
        configuration.text = joke.value
        configuration.secondaryText = "Loaded: " + joke.dateLoaded.formatted(date: .numeric, time: .shortened)
        
        cell.contentConfiguration = configuration
        
        return cell
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            jokesRealmService.deleteJoke(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
