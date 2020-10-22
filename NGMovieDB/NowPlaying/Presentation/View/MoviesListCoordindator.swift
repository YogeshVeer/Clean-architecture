//
//  NowPlayingCoordinator.swift
//  NGMovieDB
//
//  Created by Yogesh on 25.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

typealias NowPlayingCoordinatorFactory = (UINavigationController) -> MoviesListCoordinatorType

protocol MoviesListCoordinatorType: CoordinatingChildren {
    func showDetail(for model: MoviePresentationModel)
    func showAlert(title: String, message: String,
                   preferredStyle: UIAlertController.Style,
                   completion: (() -> Void)?)
}

extension MoviesListCoordinatorType {
    func showAlert(title: String = "", message: String,
                   preferredStyle: UIAlertController.Style = .alert,
                   completion: (() -> Void)? = nil) {
        showAlert(title: title, message: message, preferredStyle: preferredStyle, completion: completion)
    }
}

class MoviesListCoordindator: MoviesListCoordinatorType {
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: CoordinatingChildren?
    
    private weak var navigationController: UINavigationController?
    private let detailCoordinatorFactory: MovieDetailCoordinatorFactory
    
    convenience init(navigationController: UINavigationController) {
        self.init(navigationController: navigationController,
                  detailCoordinatorFactory: MovieDetailCoordinator.init)
    }
    
    init(navigationController: UINavigationController,
         detailCoordinatorFactory: @escaping MovieDetailCoordinatorFactory) {
        self.navigationController = navigationController
        self.detailCoordinatorFactory = detailCoordinatorFactory
    }
    
    func start() {
        guard let navigationController = navigationController else {
            return
        }
        let contoller = MoviesListViewController.instantiate()
        contoller.viewModel = MoviesListViewModel(coordinator: self)
        navigationController.pushViewController(contoller, animated: false)
    }
    
    func showDetail(for model: MoviePresentationModel) {
        guard let navigationController = navigationController else {
            return
        }
        let coordinator = detailCoordinatorFactory(navigationController,model)
        present(child: coordinator)
    }
    
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        guard let navigationController = navigationController else {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        navigationController.present(alert, animated: true, completion: completion)
    }
}
