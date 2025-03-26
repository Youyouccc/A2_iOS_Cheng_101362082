//
//  ViewController.swift
//  A2_iOS_Cheng_101362082
//
//  Created by Cheng Shi on 2025-03-25.
//

import UIKit
import CoreData

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productProviderTextField: UITextField!

    var products: [Product] = [] // All products from Core Data
    var filteredProducts: [Product] = [] // Search results
    var isSearching = false // Track search state

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        fetchProducts()
    }

    //  Set up UISearchBar
    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search by Name or Description"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }

    // Set up UITableView
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // Fetch products from Core Data
    func fetchProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            products = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            filteredProducts = products // Default to all products
            tableView.reloadData()
        } catch {
            print("Error fetching products: \(error)")
        }
    }

    // Search logic
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

    // UITableView DataSource Methods
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

    //  Save a new product to Core Data
    @IBAction func saveProduct(_ sender: Any) {
        let context = PersistenceController.shared.container.viewContext
        let newProduct = Product(context: context)

        newProduct.productName = productNameTextField.text
        newProduct.productDescription = productDescriptionTextField.text
        newProduct.productPrice = Decimal(string: productPriceTextField.text ?? "0") ?? 0
        newProduct.productProvider = productProviderTextField.text

        do {
            try context.save()
            fetchProducts() // Refresh the list after saving


            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save new product: \(error)")
        }
    }
}
