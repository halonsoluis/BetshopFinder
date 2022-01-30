//
//  MainCompositionRoot.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 30/01/2022.
//

import Foundation
import UIKit
import BetshopAPI

protocol MainRooter {
    func presentDetails(store: Betshop?)
}

final class MainCompositionRoot {

    private func createMapKitView() -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateInitialViewController() as! MapViewController
    }

    private func prepareMainView() -> UIViewController {
        let mapView = createMapKitView()
        let router = Router(mainViewResolver: { mapView.view })

        let presenter = MapViewPresenter(
            betshopAPI: SuperologyBetshopAPI.defaultBetshopAPI(),
            userLocation: UserLocationHandler(),
            router: router,
            mapView: ThreadSafeMapView(mapView: mapView)
        )
        let mapHandler = MapHandler(delegate: presenter)

        mapView.mapHandler = mapHandler
        mapView.presenter = presenter

        return mapView
    }

    func createWindowFor(scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        window.rootViewController = prepareMainView()
        window.makeKeyAndVisible()
        return window
    }
}
