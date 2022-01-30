//
//  MainCompositionRoot.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 30/01/2022.
//

import Foundation
import UIKit
import BetshopAPI

final class MainCompositionRoot {

    private func createMapKitView() -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateInitialViewController() as! MapViewController
    }

    private func prepareMainView() -> UIViewController {
        let mapView = createMapKitView()

        let presenter = MapViewPresenter(
            betshopAPI: SuperologyBetshopAPI.defaultBetshopAPI(),
            userLocation: UserLocationHandler()
        )
        presenter.mapView = ThreadSafeMapView(mapView: mapView)
        mapView.mapHandler = MapHandler(delegate: presenter)

        return mapView
    }

    func createWindowFor(scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        window.rootViewController = prepareMainView()
        window.makeKeyAndVisible()
        return window
    }
}
