//
//  MoviePresentationMapper.swift
//  NGMovieDB
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

class MoviePresentationMapper {
    func map(_ value: MovieList) -> MovieListPresentationModel {
        let movieModels = value.movies.map {
            MoviePresentationModel(id: $0.id,
                                   title: $0.title ?? "",
                                   posterPath: $0.posterPath,
                                   overview: $0.overview ?? "",
                                   rating: $0.rating ?? 0 > 0 ? "\(String($0.rating ?? 0))/10 ratings" : "No Ratings",
                                   backdropPath: $0.backdropPath)
        }
        return MovieListPresentationModel(page: value.page, totalPages: value.totalPages, movies: movieModels)
    }
}
