//
//  SpyListPresenter.swift
//  KnownSpys
//
//  Created by Joseph McCraw on 4/1/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxRelay

typealias BlockWithSource = (Source)->Void
typealias VoidBlock = ()->Void

struct SpySection {
    var header: String
    var items: [Item]
}
extension SpySection: SectionModelType {
    typealias Item = SpyDTO
    init(original: SpySection, items: [Item]) {
        self = original
        self.items = items
    }
}

protocol SpyListPresenter {
    //    var data: [SpyDTO] { get }
    var sections: BehaviorRelay<[SpySection]> { get set }
    func loadData(finished: @escaping BlockWithSource)
    func makeSomeDataChange()
}

class SpyListPresenterImplementation: SpyListPresenter {
    
    
    var sections = BehaviorRelay<[SpySection]>(value: [])
    
    
    //    var data = [SpyDTO]()
    fileprivate var modelLayer: ModelLayer
    fileprivate var bag = DisposeBag()
    fileprivate var spies = BehaviorRelay<[SpyDTO]>(value: [])
    
    init(modelLayer: ModelLayer) {
        self.modelLayer = modelLayer
        setupObservers()
    }
}

extension SpyListPresenterImplementation {
    func setupObservers() {
        spies.asObservable().subscribe(onNext: { [weak self] newSpies in
            self?.updateNewSections(with: newSpies)
            }).disposed(by: bag)
    }
    func updateNewSections(with newSpies: [SpyDTO]) {
        func mainWork() {
//            sections.value = filter( spies: newSpies)
            sections.accept(filter( spies: newSpies))
        }
        func filter(spies: [SpyDTO]) -> [SpySection] {
            let incognitoSpies = spies.filter { $0.isIncognito}
            let everydaySpies = spies.filter { !$0.isIncognito}
            return [SpySection(header: "Sneaky Spies", items: incognitoSpies),
                    SpySection(header: "Regular Spies", items: everydaySpies)]
        }
        mainWork()
    }
}

//MARK: - Data Methods
extension SpyListPresenterImplementation {
    func makeSomeDataChange() {
        let newSpy = SpyDTO(age: 23, name: "Adam Smith", gender: .male, password: "wealth", imageName: "AdamSmith", isIncognito: true)
        var newValue = spies.value
        newValue.insert(newSpy, at: 0)
        spies.accept(newValue)
    }
    
    func loadData(finished: @escaping BlockWithSource) {
        modelLayer.loadData { [weak self] source, spies in
//            self?.spies.value = spies
            self?.spies.accept(spies)
            finished(source)
        }
    }
}
