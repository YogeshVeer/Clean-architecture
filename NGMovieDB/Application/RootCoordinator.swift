//
//  RootCoordinator.swift
//  NGMovieDB
//
//  Created by Yogesh on 25.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

class RootCoordinator: CoordinatingChildren {
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: CoordinatingChildren?
    
    private weak var navigationController: UINavigationController?
    private let nowPlayingCoordinatorFactory: NowPlayingCoordinatorFactory
    
    convenience init(navigationController: UINavigationController) {
        self.init(navigationController: navigationController,
                  nowPlayingCoordinatorFactory: MoviesListCoordindator.init)
    }
    
    init(navigationController: UINavigationController,
         nowPlayingCoordinatorFactory: @escaping NowPlayingCoordinatorFactory) {
        self.navigationController = navigationController
        self.nowPlayingCoordinatorFactory = nowPlayingCoordinatorFactory
    }
    
    func start() {
        guard let navigationController = navigationController else {
            return
        }
        let nowPlayingCoordinator = nowPlayingCoordinatorFactory(navigationController)
        present(child: nowPlayingCoordinator)
    }
    
}
