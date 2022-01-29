//
//  ThreadSafeMapView.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import Foundation

final class ThreadSafeMapView: MapView {

    private weak var mapView: MapView?

    init(mapView: MapView?) {
        self.mapView = mapView
    }

    func update(with model: MapViewViewModel) {
        if Thread.isMainThread {
            mapView?.update(with: model)
        } else {
            DispatchQueue.main.async { [self] in
                mapView?.update(with: model)
            }
        }
    }
}
