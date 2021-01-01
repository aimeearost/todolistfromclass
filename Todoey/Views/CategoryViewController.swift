//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Aimee Arost on 12/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
   
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist.")
            
        }
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    // MARK: - Tableview Datasource Methods
    // (set up datasource so we can display all the categories inside persistent container)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        nil coalescing Operator
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
                
            cell.textLabel?.text = category.name
        
            guard let categoryColour = UIColor(hexString: category.colour) else {
                fatalError()
                
            }
        cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)

        }
        
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
    // MARK: - Save
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
    // MARK: - Load
    func loadCategories() {
        
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDelection = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDelection)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
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
            newCategory.colour = UIColor.randomFlat().hexValue()
            
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
