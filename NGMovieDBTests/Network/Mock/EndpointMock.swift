//
//  EndpointMock.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation
import NGMovieDB

struct EndpointMock: RequestProvider {
    var path: String
    var method: HttpMethod
    var queryParams: [String: Any] = [:]
    var headers: [String : String] = [:]
    var body: [String : Any] = [:]
    
    init(path: String, method: HttpMethod) {
        self.path = path
        self.method = method
    }
}
