//
//  MainVC.swift
//  Todoey
//
//  Created by Jonathan Go on 2018/11/26.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {
  
  let realm = try! Realm()
  var categories: Results<Category>?
  
  @IBOutlet var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadCategories()
  }
  
  
  // MARK: - Add New Category
  @IBAction func addCatBtnPressed(_ sender: UIBarButtonItem) {
    var textfield = UITextField()
    
    let alert = UIAlertController(title: "Add New ToDoey Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      //what will happen when Add Category is clicked
      let newCat = Category()
      newCat.name = textfield.text!
      if let _ = self.categories?.first(where: { $0.name.lowercased() == newCat.name.lowercased()}){
        print("Found duplicate \(String(describing: newCat.name))")
        return
      }
      
      self.saveToRealm(category: newCat)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new category"
      textfield = alertTextField
    }
    
    alert.addAction(action)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let desinationVC = segue.destination as! ToDoVC
    guard let indexPath = tableView.indexPathForSelectedRow else { return }
    desinationVC.selectedCategory = categories?[indexPath.row]
    
  }
}

// MARK: - Tableview Datasource and Delegate Methods
extension MainVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet."
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "toItems", sender: self)
  }
}

// MARK: - Data Manipulation Methods
extension MainVC {
  func saveToRealm(category: Category) {
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving context, \(error.localizedDescription)")
    }
    self.tableView.reloadData()
  }
  
  func loadCategories() {
    categories = realm.objects(Category.self)
    
    tableView.reloadData()
  }
}
