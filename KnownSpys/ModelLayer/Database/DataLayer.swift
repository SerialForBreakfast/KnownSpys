//
//  DatabaseLayer.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import UIKit
import CoreData


typealias SpiesBlock = ([Spy])->Void
protocol DataLayer {
    func save(dtos: [SpyDTO], translationLayer: TranslationLayer, finished: @escaping () -> Void)
    func loadFromDB(finished: SpiesBlock)
}

class DataLayerImplementation: DataLayer {
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KnownSpys")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(dtos: [SpyDTO], translationLayer: TranslationLayer, finished: @escaping () -> Void) {
        clearOldResults()
        
        _ = translationLayer.toUnsavedCoreData(from: dtos, with: mainContext)
        
        try! mainContext.save()
        
        finished()
    }
    
    func loadFromDB(finished: SpiesBlock) {
        print("loading data locally")
        let spies = loadSpiesFromDB()
        finished(spies)
    }
}


//MARK: - Private Data Methods
extension DataLayerImplementation {
    
    fileprivate func loadSpiesFromDB() -> [Spy] {
        let sortOn = NSSortDescriptor(key: "name", ascending: true)
        
        let fetchRequest: NSFetchRequest<Spy> = Spy.fetchRequest()
        fetchRequest.sortDescriptors = [sortOn]
        
        let spies = try! persistentContainer.viewContext.fetch(fetchRequest)
        
        return spies
    }
    
    //MARK: - Helper Methods
    fileprivate func clearOldResults() {
        print("clearing old results")
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Spy.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try! persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
        persistentContainer.viewContext.reset()
    }
}

