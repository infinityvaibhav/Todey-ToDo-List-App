//
//  ViewController.swift
//  Todey
//
//  Created by 1389028 on 08/11/20.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        print(dataFilePath)
        
//        if let items = defaults.array(forKey: "ToDoList") as? [Item] {
//            itemArray = items
//        }
        loadItems()
        
    }

    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let item = textField.text {
                let newItem = Item()
                newItem.title = item
                self.itemArray.append(newItem)
                self.saveItems()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Create new Item"
            textField = alertTextFiled
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func  saveItems() {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("catch print encoder\(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = JSONDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("catch print decoder\(error)")
            }
        }
        
    }

}
//MARK: - Data Source
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        //Ternary operator
        //value = condition ? true : false
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
}

//MARK: - Delegate
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

