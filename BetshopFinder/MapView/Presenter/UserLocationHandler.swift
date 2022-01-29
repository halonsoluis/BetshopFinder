//
//  UserLocationHandler.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import CoreLocation

class UserLocationHandler: NSObject, CLLocationManagerDelegate {
    lazy var locationManager: CLLocationManager = createLocationManager()
    var userLocation: ((CLLocation?) -> Void)?

    func startUpdating() {
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted:
            userLocation?(nil)
        case .denied:
            userLocation?(nil)
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation?(location)
        }
    }
    
    private func createLocationManager() -> CLLocationManager {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        locationManager.desiredAccuracy = kCLDistanceFilterNone
        locationManager.distanceFilter = kCLDistanceFilterNone

        return locationManager
    }
}
