//
//  ViewController.swift
//  Todoey
//
//  Created by Jonathan Go on 2018/11/24.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoVC: SwipeTableViewController {

  let realm = try! Realm()
  var todoItems: Results<Item>?
  @IBOutlet var searchBar: UISearchBar!
  
  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    title = selectedCategory?.name
    
    guard let colourHex = selectedCategory?.colour else { fatalError() }
    
    updateNavBar(withHexCode: colourHex)
  }
  
//  override func viewWillDisappear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    
//    updateNavBar(withHexCode: "1D9BF6")
//    
//  }
  
  override func willMove(toParent parent: UIViewController?) {
    super.willMove(toParent: self)
    
    updateNavBar(withHexCode: "1D9BF6")

  }
  
  // MARK: - Nav Bar Setup Methods
  func updateNavBar(withHexCode colourHexCode: String) {
    guard let navBar = navigationController?.navigationBar else {fatalError("Nav Controller does not exist")}
    
    guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
    navBar.barTintColor = navBarColour
    navBar.tintColor = ContrastColorOf(backgroundColor: navBarColour, returnFlat: true)
    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor: navBarColour, returnFlat: true)]
    searchBar.barTintColor = navBarColour
  }
  
  // MARK: - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)

    if let item = todoItems?[indexPath.row] {
      cell.textLabel?.text = item.title
      
      if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
        cell.backgroundColor = colour
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: colour, returnFlat: true)
      }
      
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No Items Added"
    }
    
    return cell
  }
  
  // MARK: - Tableview Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let item = todoItems?[indexPath.row] else { return }
    
    do {
      try realm.write {
        //realm.delete(item)
        item.done = !item.done
      }
    } catch {
      print("Error updating done status, \(error.localizedDescription)")
    }
  
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK: - Add New Items
  @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
    
    var textfield = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      //what will happen when Add Item is clicked
      if let currentCategory = self.selectedCategory {
        let newItem = Item()
        newItem.title = textfield.text!
        newItem.dateCreated = Date()
      
        do {
          try self.realm.write {
            currentCategory.items.append(newItem)
          }
        } catch {
          print("Error saving new item, \(error.localizedDescription)")
        }
      }
      self.tableView.reloadData()
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
  
  // Mark: - Manipulation Methods
  func loadItems() {
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
  }
  
  //: MARK - Delete Data from Swipe
  override func updateModel(at indexPath: IndexPath) {
    super.updateModel(at: indexPath)
    
    guard let itemForDeletion = todoItems?[indexPath.row] else { return }
    do {
      try realm.write {
        realm.delete(itemForDeletion)
      }
    } catch {
      print("Error deleting category, \(error.localizedDescription)")
    }
  }

}

//Mark: - SearchBar Methods
extension ToDoVC: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()

      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
  }
}
