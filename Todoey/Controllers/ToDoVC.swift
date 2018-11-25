//
//  ViewController.swift
//  Todoey
//
//  Created by Jonathan Go on 2018/11/24.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import UIKit
import CoreData

class ToDoVC: UITableViewController {

  var itemArray = [Item]()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let newItem = Item()
//    newItem.title = "Find Mike"
//    newItem.done = true
//    itemArray.append(newItem)
//    
//    let newItem2 = Item()
//    newItem2.title = "Buy Eggos"
//    itemArray.append(newItem2)
//
//    let newItem3 = Item()
//    newItem3.title = "Destroy Demogorgon"
//    itemArray.append(newItem3)
    
    loadItems()

//    if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//      itemArray = items
//    }

  }

  //Mark - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    let item = itemArray[indexPath.row]
    
    cell.textLabel?.text = item.title
    
    cell.accessoryType = item.done ? .checkmark : .none
    //cell.accessoryType = item.done == true ? .checkmark : .none
//    if item.done == true {
//      cell.accessoryType = .checkmark
//    }
//    else {
//      cell.accessoryType = .none
//    }
    return cell
  }
  
  //Mark - Tableview Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//    if itemArray[indexPath.row].done == false {
//      itemArray[indexPath.row].done = true
//    }
//    else {
//      itemArray[indexPath.row].done = false
//    }
    saveItems()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //Mark - Add New Items
  @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
    
    var textfield = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      //what will happen when Add Item is clicked
        let newItem = Item(context: self.context)
        newItem.title = textfield.text!
        newItem.done = false
        self.itemArray.append(newItem)
        self.saveItems()
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
  
  //Mark - Manipulation Methods
  func saveItems() {

    do {
      try context.save()
    } catch {
      print("Error saving context, \(error)")
    }
    self.tableView.reloadData()
  }
  
  func loadItems() {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context, \(error)")
    }
  }
  
}

