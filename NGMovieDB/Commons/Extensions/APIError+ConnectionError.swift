//
//  APIError+ConnectionError.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}


extension APIError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let APIError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
