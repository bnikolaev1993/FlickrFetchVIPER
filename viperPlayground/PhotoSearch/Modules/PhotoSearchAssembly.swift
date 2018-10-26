//
//  PhotoSearchAssembly.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation

class PhotoSearchAssembly {
    
    static let sharedInstance = PhotoSearchAssembly()
    
    func configure (_ viewController: PhotoViewController) {
        let APIDataManager = FlickrDataManager()
        let interactor = PhotoSearchInteractor()
        let presenter = PhotoSearchPresenter()
        let router = PhotoSearchRouting()
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        presenter.interactor = interactor
        interactor.APIDataManager = APIDataManager
        router.viewController = viewController
        presenter.router = router
    }
    
}
