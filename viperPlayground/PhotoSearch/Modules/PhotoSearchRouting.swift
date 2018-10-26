//
//  PhotoSearchRouting.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoSearchRouterInput {
    func navigateToPhotoDetail()
    func passDataToNextScene(segue: UIStoryboardSegue)
}

class PhotoSearchRouting: PhotoSearchRouterInput {
    
    weak var viewController: PhotoViewController!
    
    //MARK:- Navigation
    func navigateToPhotoDetail() {
        viewController.performSegue(withIdentifier: "showDetailVC", sender: nil)
    }
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        if segue.identifier == "showDetailVC" {
            passDataToShowPhotoDetailScene(segue: segue)
        }
    }
    
    //navigate to another module
    func passDataToShowPhotoDetailScene(segue: UIStoryboardSegue) {
        if let selectedIndexPath = viewController.photosColView.indexPathsForSelectedItems?.first {
            let selectedPhotoModel = viewController.photos[selectedIndexPath.row]
            let showDetailVC = segue.destination as! PhotoDetailViewController
            
            showDetailVC.presenter.saveSelectedPhotoModel(photoModel: selectedPhotoModel)
        }
    }
}
