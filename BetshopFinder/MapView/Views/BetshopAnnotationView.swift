//
//  BetshopAnnotationView.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import Foundation
import MapKit

final class BetshopAnnotationView: MKAnnotationView {
    static let imageSelected = "pin.selected"
    static let imageNotSelected = "pin"

    static let ReuseID = "betshop"
    static let clusterID = "storesCluster"

    override var annotation: MKAnnotation? {
            didSet {
                guard let _ = annotation as? Betshop else { return }
                
                displayPriority = .defaultLow
                clusteringIdentifier = Self.clusterID
                image = UIImage(named: Self.imageNotSelected)
            }
        }

}
