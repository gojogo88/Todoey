//
//  ViewController.swift
//  Todoey
//
//  Created by Jonathan Go on 2018/11/24.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import UIKit

class ToDoVC: UITableViewController {

  var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
      itemArray = items
    }

  }

  //Mark - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }
  
  //Mark - Tableview Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //Mark - Add New Items
  @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
    
    var textfield = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      //what will happen when Add Item is clicked
      if let textfield = textfield.text {
        self.itemArray.append(textfield)
        self.defaults.set(self.itemArray, forKey: "ToDoListArray")
        self.tableView.reloadData()
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textfield = alertTextField
    }
    
    
    alert.addAction(action)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
}

