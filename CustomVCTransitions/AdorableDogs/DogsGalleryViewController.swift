//
//  ViewController.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 16/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit
import CoreGraphics

class DogsGalleryViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    private static var collectionViewTag = 1000
    
    private var dogs = [Dog]()
    private let cellIdentifier = "photoCell"

    lazy var dogPresenter = DogsPresenter(interactor: DogsInteractor())
    lazy var settingsWireframe = SettingsWireframe()
    lazy var photoDetailsWireframe: PhotoDetailsWireFrame = {
        var navigationController = self.navigationController ?? UINavigationController(rootViewController: self)
        return PhotoDetailsWireFrame(navigationController: navigationController)
    } ()

    override func viewDidLoad() {
        collectionView.register(
            UINib(nibName: "DogPhotoCell", bundle: Bundle.main),
            forCellWithReuseIdentifier: cellIdentifier
        )
        loadDogs()
        collectionView.tag = DogsGalleryViewController.collectionViewTag
        navigationItem.title = "Gallery"
    }

    func loadDogs() {
        dogPresenter.loadDogs {[weak self] dogs in
            self?.dogs = dogs
            self?.collectionView.reloadData()
        }
    }

    @IBAction func didTapSettings(_ sender: Any) {
        settingsWireframe.showSettings(onViewController: self)
    }
    
    func calculateCellSize() -> CGSize {
        let padding = CGFloat(20.0)
        let cellsPerRow = CGFloat(3.0)
        let safeAreaInsets = view.safeAreaInsets.left + view.safeAreaInsets.right
        let size = floor((collectionView.frame.width - padding - safeAreaInsets) / cellsPerRow)
        
        return CGSize(width: size, height: size)
    }
}

extension DogsGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
}

extension DogsGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoCell = cell as? DogPhotoCell,
            dogs.count > indexPath.row else { return }
        
        photoCell.configureCell(withPhotoURL: dogs[indexPath.row].pictureURL)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard dogs.count > indexPath.row else { return }
        photoDetailsWireframe.showPhotoDetails(photoURL: dogs[indexPath.row].pictureURL)
    }
    
}

extension DogsGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return calculateCellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}

extension DogsGalleryViewController: CollectionViewProvider {
    var collectionViewKey: Int {
        return DogsGalleryViewController.collectionViewTag
    }
}
