//
//  CategoryTableController.swift
//  ChuckieJokes
//
//  Created by Ляпин Михаил on 22.06.2023.
//

import UIKit

class CategoryTableController: UITableViewController {

    weak var delegate: CategoriesTableController?
    private var jokesOfSelectedCategory: [Joke] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = delegate?.selectedCategory
        jokesOfSelectedCategory = JokesRealmService.shared.jokes.filter({$0.category[0] == delegate?.selectedCategory})
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jokesOfSelectedCategory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        
        configuration.text = jokesOfSelectedCategory[indexPath.row].value
        
        cell.selectionStyle = .none
        cell.contentConfiguration = configuration
        return cell
    }
}
