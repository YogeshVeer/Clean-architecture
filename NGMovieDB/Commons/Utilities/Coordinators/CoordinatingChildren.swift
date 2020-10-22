//
//  CoordinatingChildren.swift
//  NGMovieDB
//
//  Created by Yogesh on 25.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol CoordinatingChildren: Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func present(child: Coordinator)
    func remove(child: Coordinator)
}

extension CoordinatingChildren {
    func present(child: Coordinator) {
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
    
    func remove(child: Coordinator) {
        childCoordinators.removeAll(where: { $0 === child })
    }
}
