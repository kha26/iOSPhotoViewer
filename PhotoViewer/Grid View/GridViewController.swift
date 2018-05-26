//
//  GridViewController.swift
//  PhotoViewer
//
//  Created by Kemal Hasan Atay on 5/21/18.
//  Copyright © 2018 Hasan Atay. All rights reserved.
//

import UIKit

class GridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let numberOfPhotosPerRow: CGFloat = 4;
    var photos: [Photo]!;
    
    class func fromStoryboard(photos: [Photo]) -> GridViewController? {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "GridViewController") as! GridViewController;
        vc.photos = photos;
        return vc;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "Flickr Photo Grid";
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "list"), style: .plain, target: self, action: #selector(self.switchToList));
    }
    
    @objc func switchToList() {
        if let gvc = ListViewController.fromStoryboard(photos: self.photos) {
            self.navigationController?.setViewControllers([gvc], animated: false);
        } else {
            infoPrint("Error: Couldn't init GridViewController");
        }
    }
    
    //MARK: - CollectionView Methods
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true);
        
        if let vc = LargeImageViewController.fromStoryboard(photo: photos[indexPath.row]) {
            self.present(vc, animated: true, completion: nil);
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_grid", for: indexPath) as! GridCell;
        let photo = photos[indexPath.row];
        cell.id = photo.id;
        photo.getThumbnail { (image, error) in
            if (cell.id == photo.id) {
                cell.imgPhoto.image = image;
            }
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.width / numberOfPhotosPerRow;
        return CGSize(width: w, height: w);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude;
    }
}
