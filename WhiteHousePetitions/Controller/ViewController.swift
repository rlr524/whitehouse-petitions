//
//  ViewController.swift
//  WhiteHousePetitions
//
//  Created by Robert Ranf on 6/7/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var petitionsFiltered = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterResults))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseData(json: data)
                petitionsFiltered = petitions
                return
            }
        }
        showError()
    }
    
    func parseData(json: Data) {
        let decoder = JSONDecoder()
        
        // The method decoder.decode is a throwing method so use try? to check if it worked
        // The decode method is deserializing the JSON
        // There is an alternate class named JSONEncoder we can use the serialize (encode) our JSON if sending it back to an API
        // Use Petitions.self here as referring directly to the Petitions struct, not an instance of the struct
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitionsFiltered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitionsFiltered[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed. Please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        let text = """
Data from the White House "We the People" API
"""
        let ac = UIAlertController(title: "Credits", message: text, preferredStyle: .alert)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // FIXME: This is filtering on the search however the DetatilViewController is showing detail from the first item regarless of search results
    // FIXME: There is no means to clear the search results
    
    @objc func filterResults() {
        let ac = UIAlertController(title: "Search", message: "Enter a search term", preferredStyle: .alert)
        ac.addTextField()
        let submitSearch = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] action in
        guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitSearch)
        present(ac, animated: true)
    }
    func submit(_ answer: String) {
        petitionsFiltered.removeAll(keepingCapacity: true)
        for x in petitions {
            if x.title.contains(answer) {
                petitionsFiltered.append(x)
                tableView.reloadData()
            }
        }
    }
}
