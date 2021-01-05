//
//  CategoryTableViewController.swift
//  Todey
//
//  Created by 1389028 on 31/12/20.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        loadCategory()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let item = textField.text {
                
                let newCategory = Category()
                newCategory.name = item
                DispatchQueue.global(qos: .background).async {
                    self.save(category: newCategory)
                }
                
            }
        }
        
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Add new category"
            textField = alertTextFiled
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name
        return cell
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data manipulation methods
    
    func  save(category: Category) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("catch saveItems \(error)")
        }
        DispatchQueue.main.sync {
            tableView.reloadData()
        }
    }
    
    func loadCategory() {
        
        do {
            let realm = try Realm()
            categories = realm.objects(Category.self)
        } catch {
            print("error in load categories \(error)")
        }
        
        tableView.reloadData()
    }
}
