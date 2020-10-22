//
//  MovieCollectionCellViewModel.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol MoviewCollectionCellViewModelInput {
    func updatePosterImage(width: Int)
}

protocol MoviewCollectionCellViewModeOutput {
    var posterImage: Observable<Data?> { get }
    var posterPath: String? { get }
}

typealias MoviewCollectionCellViewModelType =  MoviewCollectionCellViewModelInput & MoviewCollectionCellViewModeOutput


class MoviewCollectionCellViewModel: MoviewCollectionCellViewModelType {
    let posterImage: Observable<Data?> = Observable(nil)
    let posterPath: String?
    private let interactor: ImageDownloadInteractorType
    
    convenience init(model: MoviePresentationModel) {
        self.init(model: model,
                  interactor: ImageDownloadInteractor(poster: model.posterPath))
    }
    
    init(model: MoviePresentationModel, interactor: ImageDownloadInteractorType) {
        self.posterPath = model.posterPath
        self.interactor = interactor
    }
    
}

extension MoviewCollectionCellViewModel {        
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
}
