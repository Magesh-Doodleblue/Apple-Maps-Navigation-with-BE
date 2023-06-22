////
////  PersistantManager.swift
////  Map Storyboard
////
////  Created by DB-MM-011 on 20/06/23.
//
//import CoreData
//
//class PersistenceManager {
//    static let shared = PersistenceManager()
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Map_Storyboard") // Replace with your actual data model name
//        container.loadPersistentStores { (_, error) in
//            if let error = error {
//                fatalError("Failed to load Core Data stack: \(error)")
//            }
//        }
//        return container
//    }()
//
//    var context: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//}
