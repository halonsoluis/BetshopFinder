//
//  Router.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 30/01/2022.
//

import UIKit

final class Router: MainRouter {
    private weak var detailView: UIView?
    private var mainView: () -> UIView?

    init(mainViewResolver: @escaping () -> UIView?) {
        self.mainView = mainViewResolver
    }

    func presentDetails(store: Betshop?) {
        guard let store = store, let view = mainView() else {
            removeDetailViewIfNeeded()
            return
        }
        let detailView = createDetails(for: store)
        self.detailView = detailView
        attachView(detailView, atTheBottomOf: view)
    }

    private func removeDetailViewIfNeeded() {
        detailView?.removeFromSuperview()
    }

    private func createDetails(for store: Betshop) -> UIView {
        let details = DetailView()
            .makeUI(store)

        details.view.backgroundColor = .clear

        return details.view
    }

    private func attachView(_ bottomView: UIView, atTheBottomOf view: UIView) {
        view.addSubview(bottomView)

        bottomView.translatesAutoresizingMaskIntoConstraints = false

        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive =  true
    }
}
