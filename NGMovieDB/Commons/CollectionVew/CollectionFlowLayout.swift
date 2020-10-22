//
//  MoviesFlowLayout.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

class CollectionFlowLayout: UICollectionViewFlowLayout {
    
    init(width: Double, height: Double, margin: CGFloat = 16.0) {
        super.init()
        itemSize = CGSize(width: width, height: height)
        sectionInset = UIEdgeInsets(top: margin, left: margin,
                                    bottom: margin, right: margin)
        footerReferenceSize = CGSize(width: width, height: 55)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
