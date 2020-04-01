//
//  SpyListPresenter.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import Outlaw



typealias BlockWithSource = (Source)->Void
typealias VoidBlock = ()->Void
typealias SpiesAndSourceBlock = (Source, [Spy])->Void
typealias SpiesBlock = ([Spy])->Void

class SpyListPresenter {
    
    var data = [Spy]()
    
}

//MARK: - Data Methods
extension SpyListPresenter {
    
    func loadData(finished: @escaping BlockWithSource) {
        loadData { [weak self] source, spies in
            self?.data = spies
            finished(source)
        }
    }
}

//MARK: - Model Methods
extension SpyListPresenter {
    
    func loadData(resultsLoaded: @escaping SpiesAndSourceBlock) {
        func mainWork() {
            
            loadFromDB(from: .local)
            
            loadFromServer { data in
                let dtos = self.createSpyDTOsFromJsonData(data)
                self.save(dtos: dtos) {
                    loadFromDB(from: .network)
                }
            }
        }
        
        func loadFromDB(from source: Source) {
            loadFromDBWith { spies in
                resultsLoaded(source, spies)
            }
        }
        
        mainWork()
    }
}

//MARK: - Network Methods
extension SpyListPresenter {
    func loadFromServer(finished: @escaping (Data) -> Void) {
        print("loading data from server")
        Alamofire.request(URL(string: "http://localhost:8080/spies")!).responseJSON { response in
            guard let data = response.data else { return }
            finished(data)
        }
    }
    
}

//MARK: - Data Methods
extension SpyListPresenter {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var persistentContainer: NSPersistentContainer {
        return appDelegate.persistentContainer
    }
    
    var mainContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func save(dtos: [SpyDTO], finished: @escaping () -> Void) {
        clearOldResults()
        
        _ = toUnsavedCoreData(from: dtos, with: mainContext)
        
        try! mainContext.save()
        
        finished()
    }
    
    func loadFromDBWith(finished: SpiesBlock) {
        print("loading data locally")
        let spies = loadSpiesFromDB()
        finished(spies)
    }
}


//MARK: - Private Data Methods
extension SpyListPresenter {
    
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

//MARK: - Translation Methods
extension SpyListPresenter {
    
    func createSpyDTOsFromJsonData(_ data: Data) -> [SpyDTO] {
        print("converting json to DTOs")
        let json:[String: Any] = try! JSON.value(from: data)
        let spies: [SpyDTO] = try! json.value(for: "spies")
        return spies
    }
    
    func toUnsavedCoreData(from dtos: [SpyDTO], with context: NSManagedObjectContext) -> [Spy] {
        print("convering DTOs to Core Data Objects")
        let spies = dtos.flatMap{ dto in translate(from: dto, with: context) } // keeping it simple by keeping things single threaded
        
        return spies
    }
    
    func toSpyDTOs(from spies:[Spy]) -> [SpyDTO] {
        let dtos = spies.flatMap { translate(from: $0) }
        
        return dtos
    }
}

//MARK: - Spy Translation Methods
extension SpyListPresenter {
    
    func translate(from spy: Spy?) -> SpyDTO? {
        guard let spy = spy else { return nil }
        
        let gender = Gender(rawValue: spy.gender)!
        
        return SpyDTO(age: Int(spy.age),
                      name: spy.name,
                      gender: gender,
                      password: spy.password,
                      imageName: spy.imageName,
                      isIncognito: spy.isIncognito)
    }
    
    func translate(from dto: SpyDTO?, with context: NSManagedObjectContext) -> Spy? {
        guard let dto = dto else { return nil }
        
        let spy = Spy(context: context)
        spy.age = Int64(dto.age)
        spy.name =     dto.name
        spy.gender =     dto.gender.rawValue
        spy.password =     dto.password
        spy.imageName =     dto.imageName
        spy.isIncognito =     dto.isIncognito
        
        return spy
    }
}


