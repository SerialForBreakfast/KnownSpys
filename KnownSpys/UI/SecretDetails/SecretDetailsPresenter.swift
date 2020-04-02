//
//  SecretDetailsPresenter.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

class SecretDetailsPresenter {
    
    var spy: SpyDTO
    var password: String { return spy.password }
    
    init(with spy: SpyDTO) {
        self.spy = spy
    }
}
