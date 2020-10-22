//
//  MoviesListCoordinatorMock.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit
@testable import NGMovieDB

class MovieListCoordinatorMock: MoviesListCoordinatorType {
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: CoordinatingChildren?
    
    private(set) var isStartCalled = false
    private(set) var isDetailStartCalled = false
    private(set) var isErrorAlertShown = false

    
    func start() {
        isStartCalled = true
    }
    
    func showDetail(for model: MoviePresentationModel) {
        isDetailStartCalled = true
    }
    
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        isErrorAlertShown = true
    }
}
