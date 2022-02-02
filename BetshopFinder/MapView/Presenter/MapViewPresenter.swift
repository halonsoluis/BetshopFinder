//
//  MapViewPresenter.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import MapKit

protocol MapView: AnyObject {
    func update(with model: MapViewViewModel)
}

protocol MapViewPresenterProtocol: AnyObject {
    func viewIsLoaded()
    func userRequestedRouting()
}

protocol BetshopStoresFinder {
    func stores(in area: MKCoordinateRegion, excluding existingAnnotations: [Betshop]) async throws -> [Betshop]
}

class MapViewPresenter {
    private let betshopStoresResolver: BetshopStoresFinder
    private let userLocation: UserLocationHandler
    private let router: MainRooter
    private let mapView: MapView

    var viewModel: MapViewViewModel?

    init(betshopStoresResolver: BetshopStoresFinder,
         userLocation: UserLocationHandler,
         router: MainRooter,
         mapView: MapView) {
        self.betshopStoresResolver = betshopStoresResolver
        self.userLocation = userLocation
        self.router = router
        self.mapView = mapView
    }

    private func initialViewModel(location: CLLocation?) -> MapViewViewModel {
        guard let location = location else {
            return MapViewViewModel.defaultMunichLocation()
        }

        return MapViewViewModel(
            annotations: [],
            mapRegion: MKCoordinateRegion(center: location.coordinate, span: MapViewViewModel.defaultSpan),
            selected: nil
        )
    }
}

extension MapViewPresenter: MapViewPresenterProtocol {
    func viewIsLoaded() {
        userLocation.userLocation = { [weak self] location in
            guard let initialViewModel = self?.initialViewModel(location: location) else {
                return
            }
            self?.mapView.update(with: initialViewModel)
        }
        userLocation.startUpdating()
    }

    func userRequestedRouting() {
        guard let store = viewModel?.selected else {
            return
        }

        OpenInMapsApp.navigate(to: store)
    }
}

extension MapViewPresenter: MapHandlerDelegate {
    func newRegionVisible(region: MKCoordinateRegion, existingAnnotations: [Betshop]) async throws {

        let newBetshops = try await betshopStoresResolver.stores(in: region, excluding: existingAnnotations)

        let model = MapViewViewModel(
            annotations: newBetshops,
            mapRegion: region,
            selected: viewModel?.selected
        )

        viewModel = model

        mapView.update(with: model)
    }

    func newSelection(store: Betshop?) {
        var model = viewModel!
        model.selected = store

        viewModel = model
        mapView.update(with: model)

        router.presentDetails(store: store)
    }
}
