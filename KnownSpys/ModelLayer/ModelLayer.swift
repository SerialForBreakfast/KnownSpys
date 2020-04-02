//
//  ModelLayer.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

class ModelLayer {
    fileprivate var networkLayer = NetworkLayer()
    fileprivate var dataLayer = DataLayer()
    fileprivate var translationLayer = TranslationLayer()
    //MARK: - Model Methods
    func loadData(resultsLoaded: @escaping SpiesAndSourceBlock) {
        func mainWork() {
            
            loadFromDB(from: .local)
            
            networkLayer.loadFromServer { data in
                let dtos = self.translationLayer.createSpyDTOsFromJsonData(data)
                self.dataLayer.save(dtos: dtos, translationLayer: self.translationLayer) {
                    loadFromDB(from: .network)
                }
            }
        }
        
        func loadFromDB(from source: Source) {
            dataLayer.loadFromDB { spies in
                resultsLoaded(source, spies)
            }
        }
        
        mainWork()
    }
}
