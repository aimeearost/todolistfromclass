//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeViewController {
    

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        tableView.separatorStyle = .none
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.colour {
            
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
            
            if let navBarColour = UIColor(hexString: colourHex) {
                
            navBar.backgroundColor = navBarColour
            navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]

            searchBar.barTintColor = navBarColour
            }
        }
    }
    
    // MARK: - Tableview Datasource Methods - 2 functions
    // MARK: - this function (just start typing tableview) provdies number of rows count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    // MARK: - this function (just start typing tableview) gets the data and populates each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //            the ? here is optional chaining - will only darken if not nil
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text =  "No Items Added"
            
        }
        
        return cell
    }
    
    // MARK: - Tableview Delegate Method - detects which row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK: - Method to give cell a checkmark as accessory - check and uncheck
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    //                        if you preferred to delete item instead of checkbox, you'd swap out the next 2 lines
                    //                        realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new to-do", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what happens when user clicks Add button on the alert
            //            let newItem = Item(context: self.context)
            //            newItem.title = textField.text!
            //            newItem.done = false
            //            newItem.parentCategory = self.selectedCategory
            //            self.itemArray.append(newItem)
            //
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder =  "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Model Manipulation Methods
    
    
    //    This function has interal and extermal paramenters AND a default value.
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }
}



