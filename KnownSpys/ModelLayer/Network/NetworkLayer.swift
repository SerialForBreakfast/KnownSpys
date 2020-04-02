//
//  NetworkLayer.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import Alamofire

class NetworkLayer {
    //MARK: - Network Methods
    func loadFromServer(finished: @escaping (Data) -> Void) {
        print("loading data from server")
        Alamofire.request(URL(string: "http://localhost:8080/spies")!).responseJSON { response in
            guard let data = response.data else { return }
            finished(data)
        }
    }
}
