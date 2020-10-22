//
//  ResponseProvider.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

public protocol ResponseProvider: RequestProvider {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}
