//
//  SearchMoviesDataRepository.swift
//  NGMovieDB
//
//  Created by Yogesh on 28.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol SearchMoviesDataRepositoryType {
    @discardableResult
    func requestData(for query: String, page: Int,
                     completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable?
}

class SearchMoviesDataRepository: SearchMoviesDataRepositoryType {
    private let remoteDataSource: SearchMovieDataSource
    
    convenience init() {
        self.init(dataSource: SearchMovieRemoteDataSource())
    }
    
    init(dataSource: SearchMovieDataSource) {
        self.remoteDataSource = dataSource
    }
    
    func requestData(for query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        remoteDataSource.getMovies(query: query, page: page, completion: completion)
    }
}

extension SearchMoviesDataRepository: SearchMoviesRepository {
    func requestMovies(for query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        requestData(for: query, page: page, completion: completion)
    }
}
