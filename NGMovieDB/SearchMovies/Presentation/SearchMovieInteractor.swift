//
//  SearchMovieInteractor.swift
//  NGMovieDB
//
//  Created by Yogesh on 28.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol SearchMovieInteractorType {
    func getMovies(for query: String,
                   page: Int,
                   completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable?
}


class SearchMovieInteractor: SearchMovieInteractorType {
    
    private let searchMovieUseCase: SearchMoviesUseCaseType
    private let presentationMapper: MoviePresentationMapper
    
    convenience init() {
        self.init(searchMovieUseCase: SearchMoviesUseCase(),
                  presentationMapper: MoviePresentationMapper())
    }
    
    init(searchMovieUseCase: SearchMoviesUseCaseType,
         presentationMapper: MoviePresentationMapper) {
        self.searchMovieUseCase = searchMovieUseCase
        self.presentationMapper = presentationMapper
    }
    
    func getMovies(for query: String, page: Int, completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable? {
        searchMovieUseCase.execute(for: query, page: page) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let movieList):
                let mappedModel = strongSelf.mapToPresentationModel(model: movieList)
                completion(.success(mappedModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func mapToPresentationModel(model: MovieList) -> MovieListPresentationModel {
        presentationMapper.map(model)
    }
}
