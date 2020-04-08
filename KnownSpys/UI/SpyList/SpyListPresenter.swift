//
//  SpyListPresenter.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

typealias BlockWithSource = (Source)->Void
typealias VoidBlock = ()->Void

protocol SpyListPresenter {
    var data: [SpyDTO] { get }
    func loadData(finished: @escaping BlockWithSource)
}

class SpyListPresenterImplementation: SpyListPresenter {
    var data = [SpyDTO]()
    var modelLayer: ModelLayer
    
    init(modelLayer: ModelLayer) {
        self.modelLayer = modelLayer
    }
}

//MARK: - Data Methods
extension SpyListPresenterImplementation {
    func loadData(finished: @escaping BlockWithSource) {
        modelLayer.loadData { [weak self] source, spies in
            self?.data = spies
            finished(source)
        }
    }
}
