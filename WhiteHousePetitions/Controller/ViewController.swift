//
//  ViewController.swift
//  WhiteHousePetitions
//
//  Created by Robert Ranf on 6/7/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseData(json: data)
            }
        }
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
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
}

