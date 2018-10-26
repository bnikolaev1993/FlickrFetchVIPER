//
//  DetailViewController.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

protocol PhotoDetailViewControllerInput {
    func addLargeLoadedPhoto(image: UIImage)
    func addPhotoImageTitle(imageTitle: String)
}
protocol PhotoDetailViewControllerOutput {
    func saveSelectedPhotoModel(photoModel: FlickrPhotoModel)
    func loadLargePhotoImage()
    func getPhotoImageTitle()
}

class PhotoDetailViewController: UIViewController, PhotoDetailViewControllerInput {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var presenter: PhotoDetailViewControllerOutput!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotoDetailAssembly.sharedInstance.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //ask title and image from presenter
        presenter.getPhotoImageTitle()
        presenter.loadLargePhotoImage()
    }
    
    //result comes from presenter
    func addLargeLoadedPhoto(image: UIImage) {
        self.imageView.image = image
    }
    
    func addPhotoImageTitle(imageTitle: String) {
        self.titleLabel.text = imageTitle
    }

}
