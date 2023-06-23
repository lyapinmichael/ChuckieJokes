//
//  CategoriesTableController.swift
//  ChuckieJokes
//
//  Created by Ляпин Михаил on 22.06.2023.
//

import UIKit

class CategoriesTableController: UITableViewController {

    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories.shared.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        
        configuration.text = Categories.shared[indexPath.row]
        
        cell.contentConfiguration = configuration
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategory" {
            (segue.destination as? CategoryTableController)?.delegate = self
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCategory = Categories.shared[indexPath.row]
        performSegue(withIdentifier: "showCategory", sender: self)
    }

}
