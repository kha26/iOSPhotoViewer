//
//  LargeImageViewController.swift
//  PhotoViewer
//
//  Created by Kemal Hasan Atay on 5/21/18.
//  Copyright © 2018 Hasan Atay. All rights reserved.
//

import UIKit

class LargeImageViewController: UIViewController {
    var photo: Photo;
    private var btnClose: UIButton!;
    private var displayingClose = false;
    
    init(photo: Photo) {
        self.photo = photo;
        super.init(nibName: nil, bundle: nil);
        self.modalTransitionStyle = .crossDissolve;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = UIColor.black;//.withAlphaComponent(0.2);
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleClose)));
        self.view.isUserInteractionEnabled = true;
        
        let imageView = UIImageView(frame: self.view.bounds);
        imageView.frame = self.view.bounds;
        imageView.contentMode = .scaleAspectFit;
        self.view.addSubview(imageView);
        
        photo.getThumbnail { (thumbnail, error) in
            if let image = thumbnail,
                imageView.image == nil {
                imageView.image = image;
            }
        }
        
        photo.getImage { (image, error) in
            if let image = image {
                imageView.image = image;
            }
        }
        
        let w: CGFloat = 80;
        btnClose = UIButton(frame: CGRect(x: view.bounds.width - w, y: 0, width: w, height: w/2));
        btnClose.setTitle("Close", for: .normal);
        btnClose.setTitleColor(UIColor.white, for: .normal);
        btnClose.setTitleColor(UIColor.lightGray, for: .highlighted);
        btnClose.backgroundColor = UIColor.black;
        btnClose.addTarget(self, action: #selector(self.close), for: UIControlEvents.touchUpInside);
        self.view.addSubview(btnClose);
        displayingClose = true;
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        // Toggle the close button after half a second
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.toggleClose();
        })
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func toggleClose() {
        if self.displayingClose {
            UIView.animate(withDuration: 0.2, animations: {
                self.btnClose.alpha = 0;
            }, completion: { (completed) in
                self.btnClose.removeFromSuperview();
                self.displayingClose = false;
            });
        } else {
            self.view.addSubview(self.btnClose);
            UIView.animate(withDuration: 0.2, animations: {
                self.btnClose.alpha = 1;
            }, completion: { (completed) in
                self.displayingClose = true;
            });
        }
    }
}
