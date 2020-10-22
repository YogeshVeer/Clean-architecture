//
//  MovieDetailViewModel.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailViewModelInput {
    func updatePosterImage(width: Int)
    func didMove(toParent parent: UIViewController?)
}

protocol MovieDetailViewModelOutput {
    var posterImage: Observable<Data?> { get }
    var posterPath: String? { get }
    var title: String { get }
    var overview: String { get }
    var rating: String { get }
}

typealias MovieDetailViewModelType = MovieDetailViewModelInput & MovieDetailViewModelOutput

class MovieDetailViewModel: MovieDetailViewModelType {
    private weak var coordinator: MovieDetailCoordinatorType?
    private let interactor: ImageDownloadInteractorType
    let title: String
    let overview: String
    let rating: String
    let posterPath: String?
    let posterImage: Observable<Data?> = Observable(nil)
    
    convenience init(coordinator: MovieDetailCoordinatorType,
                     movieModel: MoviePresentationModel) {
        self.init(coordinator: coordinator,
                  movieModel: movieModel,
                  interactor: ImageDownloadInteractor(poster: movieModel.backdropPath))
    }
    
    init(coordinator: MovieDetailCoordinatorType,
         movieModel: MoviePresentationModel,
         interactor: ImageDownloadInteractorType) {
        self.coordinator = coordinator
        self.interactor = interactor
        self.title = movieModel.title
        self.overview = movieModel.overview
        self.posterPath = movieModel.backdropPath
        self.rating = movieModel.rating
    }
    
}

extension MovieDetailViewModel {
    func updatePosterImage(width: Int) {
        posterImage.value = nil
        interactor.getImage(width: width) { [weak self] result in
            switch result {
            case .success(let data):
                self?.posterImage.value = data
            case .failure: break
            }
        }
    }
    
    func didMove(toParent parent: UIViewController?) {
        guard parent == nil else {
            return
        }
        coordinator?.removeFromParent()
    }
}

