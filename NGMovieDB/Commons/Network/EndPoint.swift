//
//  EndPoint.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

typealias EndpointProvider = RequestProvider & ResponseProvider

public class Endpoint<R>: EndpointProvider {
    public typealias Response = R
    
    public var path: String
    public var method: HttpMethod
    public var queryParams: [String : Any]
    public var headers: [String : String]
    public var body: [String : Any]
    public var responseDecoder: ResponseDecoder
    
    convenience init(path: String) {
        self.init(path: path,
                  method: .get,
                  queryParams: [:],
                  headers: [:],
                  body: [:],
                  responseDecoder: JSONResponseDecoder())
    }
    
    public init(path: String,
         method: HttpMethod = .get,
         queryParams: [String: Any] = [:],
         headers: [String: String] = [:],
         body: [String: Any] = [:],
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.method = method
        self.queryParams = queryParams
        self.headers = headers
        self.body = body
        self.responseDecoder = responseDecoder
    }
}
