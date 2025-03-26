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
        
    }
