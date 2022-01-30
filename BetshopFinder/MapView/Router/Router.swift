//
//  Router.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 30/01/2022.
//

import UIKit

class Router: MainRooter {
    private static let infoViewTag = 1234567890
    private var mainView: () -> UIView?

    init(mainViewResolver: @escaping () -> UIView?) {
        self.mainView = mainViewResolver
    }

    private func removeDetailViewIfNeeded() {
        guard let detailView = mainView()?.viewWithTag(Self.infoViewTag) else {
            return
        }
        detailView.removeFromSuperview()
    }

    private func createDetails(for store: Betshop) -> UIView {
        let detailView = DetailView()
            .makeUI(store)
        detailView.view.backgroundColor = .clear

        return detailView.view
    }

    private func attachView(_ bottomView: UIView, atTheBottomOf view: UIView) {
        view.addSubview(bottomView)

        bottomView.tag = Self.infoViewTag
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive =  true
    }

    func presentDetails(store: Betshop?) {
        guard let store = store, let view = mainView() else {
            removeDetailViewIfNeeded()
            return
        }

        attachView(createDetails(for: store), atTheBottomOf: view)
    }
}
