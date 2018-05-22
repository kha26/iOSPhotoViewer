//
//  ListViewController.swift
//  PhotoViewer
//
//  Created by Kemal Hasan Atay on 5/21/18.
//  Copyright © 2018 Hasan Atay. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    var photos: [Photo]!;
    
    class func fromStoryboard(photos: [Photo]) -> ListViewController? {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController;
        vc.photos = photos;
        return vc;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Flickr Photo List";
        self.tableView.tableFooterView = UIView();
        self.tableView.separatorStyle = .none;
        if (photos == nil) {
            photos = [];
            let a = DataCenter();
            a.getPhotos { (lst, error) in
                if let lst = lst {
                    self.photos = lst;
                    DispatchQueue.main.async {
                        self.tableView.reloadData();
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "#", style: .plain, target: self, action: #selector(self.switchToGrid));
                    }
                }
            }
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "#", style: .plain, target: self, action: #selector(self.switchToGrid));
        }
    }
    
    @objc func switchToGrid() {
        if let gvc = GridViewController.fromStoryboard(photos: self.photos) {
            self.navigationController?.setViewControllers([gvc], animated: false);
        } else {
            infoPrint("Error: Couldn't init GridViewController");
        }
    }
    
    //MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (photos == nil ? 0 : photos.count);
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width / 5 + ListCell.padding * 2;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home_cell") as! ListCell;
        let photo = photos[indexPath.row];
        cell.id = photo.id;
        if (indexPath.row % 2 == 1) {
            cell.backgroundColor = UIColor.groupTableViewBackground;
        } else {
            cell.backgroundColor = UIColor.white;
        }
        
        cell.lblTitle.text = photo.title;
        
        photo.getThumbnail { (image, error) in
            if (cell.id == photo.id) {
                cell.imgPhoto.image = image;
                cell.imgPhoto.clipsToBounds = true;
            }
        }
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        if let vc = LargeImageViewController.fromStoryboard(photo: photos[indexPath.row]) {
            self.present(vc, animated: true, completion: nil);
        }
    }
}

