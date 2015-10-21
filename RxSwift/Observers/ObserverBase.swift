//
//  ObserverBase.swift
//  Rx
//
//  Created by Krunoslav Zaher on 2/15/15.
//  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

class ObserverBase<ElementType> : Disposable, ObserverType {
    typealias E = ElementType
    
    var isStopped: Int32 = 0
    
    init() {
    }
    
    func on(event: RxEvent<E>) {
        switch event {
        case .Next:
            if isStopped == 0 {
                onCore(event)
            }
        case .Error, .Completed:
           
            if !OSAtomicCompareAndSwap32(0, 1, &isStopped) {
                return
            }
            
            onCore(event)
        }
    }
    
    func onCore(event: RxEvent<E>) {
        abstractMethod()
    }
    
    func dispose() {
        isStopped = 1
    }
}
