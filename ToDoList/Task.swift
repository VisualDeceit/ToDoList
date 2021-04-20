//
//  Task.swift
//  ToDoList
//
//  Created by Alexander Fomin on 19.04.2021.
//

import Foundation

protocol Task: AnyObject {
    var name: String { get }
    var parent: Task? { get set }
    var subtasks: [Task] { get set }
    
    func add(task: Task)
    func delete(at index: Int)
    func getName() -> String
    func getSubtasks() -> [Task]
    func getSubtaskCount(for index: Int) -> Int   
}

class CompositeTask: Task {
      
    var name: String
    var parent: Task?
    var subtasks = [Task]()
    
    func add(task: Task) {
        task.parent = self
        subtasks.append(task)
    }
    
    func delete(at index: Int) {
        subtasks[index].subtasks.enumerated().forEach { (i, task) in
            if task.subtasks.count != 0 {
                task.parent?.delete(at: i)
            }
            task.parent = nil
        }
        subtasks[index].subtasks.removeAll()
        subtasks[index].parent = nil
        subtasks.remove(at: index)
    }

    func getName() -> String {
        return name
    }
    
    func getSubtaskCount(for index: Int) -> Int {
        subtasks[index].subtasks.count
    }
    
    func getSubtasks() -> [Task] {
        return subtasks
    }
    
    init(name: String) {
        self.name = name
    }
}
