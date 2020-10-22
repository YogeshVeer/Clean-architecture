//
//  ImageFetchingRepository.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol ImageFetchingRepository {
    func getImage(for imagePath: String, width: Int,
                  completion: @escaping (Result<Data, Error>) -> Void) -> NetworkCancellable?
}
