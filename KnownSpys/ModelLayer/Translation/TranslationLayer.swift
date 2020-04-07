//
//  TranslationLayer.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import Outlaw
import CoreData

class TranslationLayer {
    fileprivate var spyTranslator: SpyTranslator
    
    init(spyTranslator: SpyTranslator){
        self.spyTranslator = spyTranslator
    }
    
    
    func createSpyDTOsFromJsonData(_ data: Data) -> [SpyDTO] {
        print("converting json to DTOs")
        let json:[String: Any] = try! JSON.value(from: data)
        let spies: [SpyDTO] = try! json.value(for: "spies")
        return spies
    }
    
    func toUnsavedCoreData(from dtos: [SpyDTO], with context: NSManagedObjectContext) -> [Spy] {
        print("convering DTOs to Core Data Objects")
        let spies = dtos.flatMap{ dto in spyTranslator.translate(from: dto, with: context) } // keeping it simple by keeping things single threaded
        
        return spies
    }
    
    func toSpyDTOs(from spies:[Spy]) -> [SpyDTO] {
        let dtos = spies.flatMap { spyTranslator.translate(from: $0) }
        
        return dtos
    }
}
