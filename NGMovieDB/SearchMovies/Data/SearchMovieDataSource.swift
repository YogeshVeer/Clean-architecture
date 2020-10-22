//
//  SearchMovieDataSource.swift
//  NGMovieDB
//
//  Created by Yogesh on 28.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol SearchMovieDataSource {
    @discardableResult
    func getMovies(query: String, page: Int,
                   completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable?
}
