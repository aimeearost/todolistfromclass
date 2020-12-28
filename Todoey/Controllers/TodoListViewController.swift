//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        this will actually load the items added into the itemArray, but will only do so if there have actually been additional items added.
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
//            mark updating commit
            
        }
        
        let newItem = Item()
        newItem.title = "Practice coding"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Walk the dog"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Finish the GBBS"
        itemArray.append(newItem3)
        
        
        //        tableView.delegate = self
        //        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // MARK: - Tableview Datasource Methods - 2 functions
    //    by subclassing as a tableviewcontroller, we can rely on a lot from xcode
    // MARK: - this function (just start typing tableview) provdies number of rows count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    // MARK: - this function (just start typing tableview) gets the data and populates each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        TERNARY OPERATOR ===>
//        value = condition ? valueIfTrue : valueIfFalse
//        value              condition    if true     if false
        cell.accessoryType = item.done ? .checkmark : .none
        
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
//
        return cell
    }
    
    // MARK: - Tableview Delegate Method - detects which row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK: - Method to give cell a checkmark as accessory - check and uncheck
//        if true becomes false, and if false becomes true... accomplished using "!"
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        //****************************************************
//THE ABOVE DOES THE SAME THING AS THIS, BUT MUCH MORE ELEGANTLY!
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
//        this enables the data from above to load with the checkboxes
        
        //****************************************************

        tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else  {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to-do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what happens when user clicks Add button on the alert
           let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            //This saves the newly entered item using the defaults method. This needs a key: value pair bc it saves to the plist.
//            this won't work with the itemArray, so need to change how we save the new data
            self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
            //this repopulates the tableview to actually add the new item into the array and publish in the table
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder =  "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


