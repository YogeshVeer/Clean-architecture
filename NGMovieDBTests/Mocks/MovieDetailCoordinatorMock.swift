//
//  MovieDetailCoordinatorMock.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 30.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation
@testable import NGMovieDB

class MovieDetailCoordinatorMock: MovieDetailCoordinatorType {
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: CoordinatingChildren?
    
    private(set) var isStartCalled = false
    
    func start() {
        isStartCalled = true
    }
    
}
