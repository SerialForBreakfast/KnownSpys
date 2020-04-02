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
typealias SpiesAndSourceBlock = (Source, [Spy])->Void
typealias SpiesBlock = ([Spy])->Void

class SpyListPresenter {
    
    var data = [Spy]()
    var modelLayer = ModelLayer()
}

//MARK: - Data Methods
extension SpyListPresenter {
    
    func loadData(finished: @escaping BlockWithSource) {
        modelLayer.loadData { [weak self] source, spies in
            self?.data = spies
            finished(source)
        }
    }
}





