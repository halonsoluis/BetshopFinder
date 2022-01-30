//
//  DetailView.swift
//  betshops
//
//  Created by Hugo Alonso on 30/01/2022.
//

import SwiftUI

class DetailView {
    func makeUI(_ store: Betshop) -> UIViewController {
        UIHostingController(rootView: BetshopStoreDetailsView(betshop: store))
    }
}
