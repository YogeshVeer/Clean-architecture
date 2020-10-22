//
//  NetworkConfigurationMock.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation
import NGMovieDB

class NetworkConfigurableMock: ServiceConfigurable {
    var baseURL: URL = URL(string: "https://moviedb.mock.com")!
    var headers: [String: String] = [:]
    var queryParams: [String: String] = [:]
}
