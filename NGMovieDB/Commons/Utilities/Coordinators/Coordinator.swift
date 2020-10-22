//
//  Coordinator.swift
//  NGMovieDB
//
//  Created by Yogesh on 25.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol Coordinator: AnyObject {
    var parentCoordinator: CoordinatingChildren? { get set }
    
    func start()
    func removeFromParent()
}

extension Coordinator {
    func removeFromParent() {
        parentCoordinator?.remove(child: self)
    }
}
