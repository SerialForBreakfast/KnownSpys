//
//  DetailPresenter.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

class DetailPresenter {
    var spy: SpyDTO!
    
    var imageName: String { return spy.imageName}
    var name: String { return spy.name}
    var age: String { return String(spy.age) }
    var gender: String { return spy.gender.rawValue }
    init(with spy: SpyDTO) {
        self.spy = spy
    }
}
