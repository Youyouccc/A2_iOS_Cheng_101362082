//
//  ViewController.swift
//  A2_iOS_Cheng_101362082
//
//  Created by Heather Shi on 2025-03-25.
//

import UIKit
import coreData

class ViewController: UIViewController{

    var products: [Product] = []
    var filteredProducts: [Product] = []
    var isSearching = false //track search state
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        func setupSearchBar(){
                let searchBar = UISearchBar()
                searchBar.placeholder = "Search by Name or Description"
                searchBar.delegate = self
                self.navigationItem.titleView = searchBar
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                if searchText.isEmpty {
                    isSearching = false
                    filteredProducts = products // Show all products when search bar is empty
                } else {
                    isSearching = true
                    let predicate = NSPredicate(format: "productName CONTAINS[cd] %@ OR productDescription CONTAINS[cd] %@", searchText, searchText)
                        
                    let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
                        fetchRequest.predicate = predicate
                        
                    do {
                        filteredProducts = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
                    } catch {
                        print("Error filtering products: \(error)")
                    }
                }
                tableView.reloadData()
        }
        
    }
        
}
