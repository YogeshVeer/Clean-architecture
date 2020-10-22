//
//  Storyboarded.swift
//  NGMovieDB
//
//  Created by Yogesh on 25.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {
    enum Storyboard: String {
        case main
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(_ storyboard: Storyboard) {
        self.init(name: storyboard.filename, bundle: Bundle.main)
    }
    
    func instantiateViewController<T: UIViewController>() -> T  {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return viewController
    }
}

extension UIViewController {
    static func instantiate(withStoryboard storyboard: UIStoryboard.Storyboard = .main) -> Self {
        let storyboard = UIStoryboard(name: storyboard.filename, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: Self.storyboardIdentifier) as! Self
    }
}
