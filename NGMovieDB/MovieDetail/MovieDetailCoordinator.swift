//
//  MovieDetailCoordinator.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

typealias MovieDetailCoordinatorFactory = (UINavigationController,MoviePresentationModel) -> MovieDetailCoordinatorType

protocol MovieDetailCoordinatorType: CoordinatingChildren { }

class MovieDetailCoordinator: MovieDetailCoordinatorType {
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: CoordinatingChildren?
    private var movie: MoviePresentationModel
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController,
         movie: MoviePresentationModel) {
        self.navigationController = navigationController
        self.movie = movie
    }
    
    func start() {
        guard let navigationController = navigationController else {
            return
        }
        let contoller = MoviewDetailViewController.instantiate()
        contoller.viewModel = MovieDetailViewModel(coordinator: self,movieModel: movie)
        navigationController.pushViewController(contoller, animated: true)
    }
}
