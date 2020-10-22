//
//  MovieListPresentationModel.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

struct MovieListPresentationModel {
    let page: Int
    let totalPages: Int
    let movies: [MoviePresentationModel]
}

struct MoviePresentationModel {
    let id: String
    let identifier = UUID()
    let title: String
    let posterPath: String?
    let overview: String
    let rating: String
    let backdropPath: String?
}

extension MoviePresentationModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

