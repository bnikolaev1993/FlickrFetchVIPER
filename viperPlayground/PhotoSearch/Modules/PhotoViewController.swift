//
//  PhotoViewController.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

protocol PhotoViewControllerOutput {
    
    func fetchPhotos( searchTag: String, page: Int)
    func goToPhotoDetailScreen()
    func passDataToNextScene(segue: UIStoryboardSegue)
}

protocol PhotoViewControllerInput {
    
    func displayFetchedPhotos(photos: [FlickrPhotoModel], totalPages: Int)
    func displayErrorView(error: String)
    func showWaitingView()
    func hideWaitingView()
    func getTotalPhotoCount() -> Int
}

class PhotoViewController: UIViewController, PhotoViewControllerInput {
    
    @IBOutlet weak var photosColView: UICollectionView!
    
    var presenter: PhotoViewControllerOutput!
    var photos: [FlickrPhotoModel] = []
    var currentPage = 1
    var totalPages = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotoSearchAssembly.sharedInstance.configure(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        performSearchWith(search)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = search
    }

    func performSearchWith (_ searchText: String) {
        presenter.fetchPhotos(searchTag: searchText, page: currentPage)
    }
    
    //Presenter return photos array
    func displayFetchedPhotos(photos: [FlickrPhotoModel], totalPages: Int) {
        
        self.photos.append(contentsOf: photos)
        self.totalPages = totalPages
        
        DispatchQueue.main.async {
            self.photosColView.reloadData()
        }
    }
    
    //Show error
    func displayErrorView(error: String) {
        
        let refreshAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: okAction, style: .default, handler: { (action) in
            refreshAlert.dismiss(animated: true)
        }))
        present(refreshAlert, animated: true)
    }

    //MARK:- Activity View
    func showWaitingView() {
        let alert = UIAlertController(title: nil, message: waitingKey, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        
        self.navigationController!.present(alert, animated: true)
    }
    
    func hideWaitingView() {
        self.dismiss(animated: true)
    }
    
    func getTotalPhotoCount() -> Int {
        return self.photos.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.passDataToNextScene(segue: segue)
    }
}

// MARK:- UICollectionViewDataSource
extension PhotoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentPage < totalPages {
            return photos.count + 1
        }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < photos.count {
            return photoItemCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            currentPage += 1
            performSearchWith(search)
            
            return loadingCell(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    func photoItemCell( collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoItemCell", for: indexPath) as! PhotoItemCollectionViewCell
        
        let flickrPhoto = self.photos[indexPath.row]
        
        cell.photoImageViewOutlet.alpha = 0.0
        cell.photoImageViewOutlet.sd_setImage(with: flickrPhoto.photoURL) { (image, error, cache, url) in
            cell.photoImageViewOutlet.image = image
            UIView.animate(withDuration: 0.2, animations: {
                cell.photoImageViewOutlet.alpha = 1.0
            })
        }
        
        return cell
    }
    
    func loadingCell( collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoLoadingCell", for: indexPath) as! PhotoLoadingCollectionViewCell
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.goToPhotoDetailScreen()
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize: CGSize
        let length = (UIScreen.main.bounds.width / 3) - 1
        
        if indexPath.row < photos.count {
            itemSize = CGSize(width: length, height: length)
        } else {
            itemSize = CGSize(width: photosColView.bounds.width, height: 50.0)
        }
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}



