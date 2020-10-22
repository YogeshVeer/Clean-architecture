//
//  AppConfiguration.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

final class AppConfigurations {
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("key not available")
        }
        return apiKey
    }()
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("Base url not available")
        }
        return apiBaseURL
    }()
    
    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "RES_BASE_URL") as? String else {
            fatalError("resource url not available")
        }
        return imageBaseURL
    }()
}
