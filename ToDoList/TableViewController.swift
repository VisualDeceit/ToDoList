//
//  TableViewController.swift
//  ToDoList
//
//  Created by Alexander Fomin on 19.04.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    var rootTask: CompositeTask!
    var leftBarButtonItem : UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootTask = CompositeTask(name: "root")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        
        self.leftBarButtonItem = UIBarButtonItem(title: "< Back",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapBack))
        backButtonControl()
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Task", message: "Enter new to do list task!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    self.rootTask.add(task: CompositeTask(name: text))
                    self.tableView.reloadData()
                }
            }
        }))
        alert.addTextField { field in
            field.placeholder = "Enter task ... "
            
        }
        present(alert, animated: true)
    }
    
    @objc private func didTapBack() {
        if let parent = rootTask.parent {
            rootTask = parent as? CompositeTask
            backButtonControl()
            tableView.reloadData()
        }
    }

    func backButtonControl() {
        if rootTask.parent != nil {
            navigationItem.leftBarButtonItem = self.leftBarButtonItem
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootTask.subtasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath)
        cell.textLabel?.text = rootTask.subtasks[indexPath.row].name
        
        let subtasksCount = rootTask.subtasks[indexPath.row].subtasks.count
        if subtasksCount > 0 {
            cell.detailTextLabel?.text = "Subtasks: \(subtasksCount)"
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rootTask = rootTask.subtasks[indexPath.row] as? CompositeTask
        backButtonControl()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rootTask.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
