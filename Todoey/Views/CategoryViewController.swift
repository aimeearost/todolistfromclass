//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Aimee Arost on 12/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    // MARK: - Tableview Datasource Methods
    // (set up datasource so we can display all the categories inside persistent container)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        nil coalescing Operator
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manipulation Methods
    // (set up data manipulation methods - save and load data)
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }

    // MARK: - Add New Categories
    // (add button pressed ib action)
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what happens when user clicks Add button on the alert
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        
    }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder =  "Create new category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
}

    
    

