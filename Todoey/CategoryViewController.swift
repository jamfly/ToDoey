//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jamfly on 2018/5/23.
//  Copyright © 2018 Jamfly. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    // MARK: Constant
    
    private let cellID = "categoryCell"
    private let categoryArrayKey = "categoryArrayKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: cellID)
      
        let textAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.topItem?.title = "Todoey"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        
        navigationItem.rightBarButtonItem = add
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        loadCategories()
    }
    
     // MARK: Add New Category
    
    @objc private func addButtonPressed() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // add new category to category array
            print(textField.text ?? "")
            
            guard let addString = textField.text else { return }
            if addString == "" { return }
            
            let newItem = Category(context: self.context)
            newItem.name = addString
            
            self.categoryArray.append(newItem)
            
            self.saveCategories()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Model
    
    private var categoryArray: [Category] = []
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func saveCategories() {
        // let encoder = PropertyListEncoder()
        do {
            try context.save()
        } catch {
            print("Error saving context\(error)")
        }
        
        tableView.reloadData()
    }
    
    private func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let category = categoryArray[indexPath.row]
        
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
}