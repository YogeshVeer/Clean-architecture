//
//  NetworkConfiguration.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

public protocol ServiceConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParams: [String: String] { get }
}

public struct NetworkConfiguration: ServiceConfigurable {
    public let baseURL: URL
    public let headers: [String: String]
    public let queryParams: [String: String]
}

extension NetworkConfiguration {
    init(baseURL: URL) {
        self.init(baseURL: baseURL,
                  headers: [:],
                  queryParams: [:])
    }
}
