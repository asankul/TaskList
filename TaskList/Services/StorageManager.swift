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
        
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    // MARK: - Core Data CRUD Functions
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()

        do {
            let taskList = try context.fetch(fetchRequest)
            completion(.success(taskList))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func saveData(title taskName: String, completion: (Task) -> Void) {
        let task = Task(context: context)
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func deleteData(task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func editData(task: Task, taskName: String) {
        task.title = taskName
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
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
