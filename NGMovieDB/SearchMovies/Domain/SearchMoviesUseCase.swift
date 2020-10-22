//
//  SearchMoviesUseCase.swift
//  NGMovieDB
//
//  Created by Yogesh on 28.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol SearchMoviesUseCaseType {
    func execute(for query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable?
}

class SearchMoviesUseCase: SearchMoviesUseCaseType {
    private let searchMovieRepository: SearchMoviesRepository
    
    convenience init() {
        self.init(searchMovieRepository: SearchMoviesDataRepository())
    }
    
    init(searchMovieRepository: SearchMoviesRepository) {
        self.searchMovieRepository = searchMovieRepository
    }
    
    func execute(for query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        searchMovieRepository.requestMovies(for: query, page: page, completion: completion)
    }
}
