//
//  ViewController.swift
//  A2_iOS_Cheng_101362082
//
//  Created by Heather Shi on 2025-03-25.
//

import UIKit
import coreData

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate{

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
        
        func fetchProducts() {
                let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
                    
                do {
                    let fetchedProducts = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
                    self.products = fetchedProducts
                    self.filteredProducts = fetchedProducts // Default to all product
                        tableView.reloadData()
                } catch {
                    print("Error fetching products: \(error)")
                }
            }
        setupSearchBar()
        fetchProducts()
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                    return isSearching ? filteredProducts.count : products.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
                    let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
                    
                    cell.textLabel?.text = product.productName
                    cell.detailTextLabel?.text = product.productDescription
                    
                    return cell
                }
        
        @IBAction func saveProduct(_ sender: Any) {
            let context = PersistenceController.shared.container.viewContext
            let newProduct = Product(context: context)
            
            newProduct.productName = productNameTextField.text
            newProduct.productDescription = productDescriptionTextField.text
            newProduct.productPrice = Decimal(string: productPriceTextField.text ?? "0") ?? 0
            newProduct.productProvider = productProviderTextField.text
            
            do {
                    try context.save()
                    navigationController?.popViewController(animated: true)
                } catch {
                    print("Failed to save new product: \(error)")
                }
            
        }
    }
        
}
