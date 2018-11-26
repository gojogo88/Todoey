//
//  MainVC.swift
//  Todoey
//
//  Created by Jonathan Go on 2018/11/26.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

  @IBOutlet var tableView: UITableView!
  var catArray = [Category]()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.isHidden = false
      loadCoreDataObjects()
    }
  
  func loadCoreDataObjects() {
    self.fetchData { (complete) in
      if complete {
        if catArray.count >= 1 {
          tableView.isHidden = false
        } else {
          tableView.isHidden = true
        }
      }
    }
  }
  
  // MARK: - Add New Category
  @IBAction func addCatBtnPressed(_ sender: UIBarButtonItem) {
    var textfield = UITextField()
    
    let alert = UIAlertController(title: "Add New ToDoey Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      //what will happen when Add Category is clicked
      let newCat = Category(context: context)
      newCat.name = textfield.text!
      if let _ = self.catArray.first(where: { $0.name?.lowercased() == newCat.name?.lowercased()}){
        print("Found duplicate \(String(describing: newCat.name))")
        return
      }
      
      self.catArray.append(newCat)
      self.saveData()
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
    desinationVC.selectedCategory = catArray[indexPath.row]
    
  }
}

// MARK: - Tableview Datasource and Delegate Methods
extension MainVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return catArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
    cell.textLabel?.text = catArray[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "toItems", sender: self)
  }
}

// MARK: - Data Manipulation Methods
extension MainVC {
  func saveData() {
    do {
      try context.save()
    } catch {
      print("Error saving context, \(error.localizedDescription)")
    }
    self.tableView.reloadData()
  }
  
  func fetchData(completion: (_ complete: Bool) ->()) {
    let request = NSFetchRequest<Category>(entityName: "Category")
    do {
      catArray = try context.fetch(request)
      completion(true)
    } catch {
      print("Error fetching data from context, \(error.localizedDescription)")
      completion(false)
    }
  }
}
