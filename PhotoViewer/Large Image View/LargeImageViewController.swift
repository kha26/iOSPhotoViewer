//
//  LargeImageViewController.swift
//  PhotoViewer
//
//  Created by Kemal Hasan Atay on 5/21/18.
//  Copyright © 2018 Hasan Atay. All rights reserved.
//

import UIKit

class LargeImageViewController: UIViewController {
    var photo: Photo!;
    private var displayingClose = false;
    @IBOutlet weak var btnClose: UIButton!;
    @IBOutlet weak var imageView: UIImageView!
    
    class func fromStoryboard(photo: Photo) -> LargeImageViewController? {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LargeImageViewController") as! LargeImageViewController;
        vc.photo = photo;
        return vc;
    }
    
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.modalTransitionStyle = .crossDissolve;
        
        self.view.backgroundColor = UIColor.black;//.withAlphaComponent(0.2);
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleClose)));
        self.view.isUserInteractionEnabled = true;
        
        btnClose.setTitleColor(UIColor.lightGray, for: .highlighted);
        btnClose.addTarget(self, action: #selector(self.close), for: UIControlEvents.touchUpInside);
        displayingClose = true;
        
        photo.getThumbnail { (thumbnail, error) in
            if let image = thumbnail,
                self.imageView.image == nil {
                self.imageView.image = image;
            }
        }
        
        photo.getImage { (image, error) in
            if let image = image {
                self.imageView.image = image;
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        // Toggle the close button after half a second
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        //    self.toggleClose();
        //})
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func toggleClose() {
        if self.displayingClose {
            UIView.animate(withDuration: 0.2, animations: {
                self.btnClose.alpha = 0;
            }, completion: { (completed) in
                self.btnClose.isEnabled = false;
                self.displayingClose = false;
            });
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.btnClose.alpha = 1;
            }, completion: { (completed) in
                self.displayingClose = true;
                self.btnClose.isEnabled = true;
            });
        }
    }
}
