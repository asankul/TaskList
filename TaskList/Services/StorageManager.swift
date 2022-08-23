//
//  StorageManager.swift
//  TaskList
//
//  Created by Асанкул Садыков on 23/8/22.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data CRUD Functions
    func fetchData() -> [Task] {
        var taskList: [Task] = []
        let fetchRequest = Task.fetchRequest()
        let context = persistentContainer.viewContext
        do {
            taskList = try context.fetch(fetchRequest)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return taskList
    }
    
    func saveData(title taskName: String) -> Task {
        let context = persistentContainer.viewContext
        let task = Task(context: context)
        task.title = taskName
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        return task
    }
    
    func deleteData(task: Task) {
        let context = persistentContainer.viewContext
        context.delete(task)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func editData(task: Task, taskName: String) {
        let context = persistentContainer.viewContext
        task.title = taskName
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
