//
//  ViewController.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 16/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit
import CoreGraphics

class DogsGalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dogs = [Dog]()
    private let cellIdentifier = "photoCell"
    lazy var dogPresenter = DogsPresenter(interactor: DogsInteractor())
    override func viewDidLoad() {
        collectionView.register(UINib(nibName: "DogPhotoCell", bundle: Bundle.main), forCellWithReuseIdentifier: cellIdentifier)
        loadDogs()
    }

    func loadDogs() {
        dogPresenter.loadDogs {[weak self] dogs in
            self?.dogs = dogs
            self?.collectionView.reloadData()
        }
    }

    @IBAction func didTapSettings(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        if let viewController = viewController {
            present(viewController, animated: true, completion: nil)
        }
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
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoDetailViewController") as? PhotoDetailViewController
        
        if let viewController = viewController {
            viewController.photoURL = dogs[indexPath.row].pictureURL
            navigationController?.pushViewController(viewController, animated: true)
        }
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