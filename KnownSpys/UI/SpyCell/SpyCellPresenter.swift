//
//  SpyCellPresenter.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

protocol SpyCellPresenter {
    var age: Int { get }
    var name: String { get }
    var imageName: String { get }
}

class SpyCellPresenterImplementation: SpyCellPresenter {
    var spy: SpyDTO!
    var age: Int { return Int(spy.age) }
    var name: String { return spy.name }
    var imageName: String { return spy.imageName }
    
    init(with spy: SpyDTO) {
        self.spy = spy
    }
}
