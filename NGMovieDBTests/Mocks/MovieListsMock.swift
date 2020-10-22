//
//  MovieListsMock.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation
@testable import NGMovieDB

class MovieListsMock {
    static let moviesPages: [MovieList] = {
        let page1 = MovieList(page: 1, totalPages: 2, movies: [
            Movie(id: "1", title: "title1", posterPath: "/path1", overview: "overview1", rating: 10, backdropPath: "/path1"),
            Movie(id: "2", title: "title2", posterPath: "/path2", overview: "overview2", rating: 10, backdropPath: "/path3")])
        let page2 = MovieList(page: 2, totalPages: 2, movies: [
            Movie(id: "3", title: "title3", posterPath: "/path3", overview: "overview3", rating: 10, backdropPath: "/path3")])
        return [page1, page2]
    }()

}
