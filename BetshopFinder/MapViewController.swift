//
//  MapViewController.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
    }

    func configureMap() {
        map.delegate = self
    }
}

