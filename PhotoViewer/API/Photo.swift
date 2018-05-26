//
//  Photo.swift
//  PhotoViewer
//
//  Created by Kemal Hasan Atay on 5/21/18.
//  Copyright © 2018 Hasan Atay. All rights reserved.
//

import UIKit

class Photo {
    var id: String?;
    var title: String?;
    var imageLink: String?;
    var thumbnailLink: String? {
        return imageLink?.replacingOccurrences(of: ".png", with: "_t.png").replacingOccurrences(of: ".jpg", with: "_t.jpg");
    }
    private var image: UIImage?;
    private var thumbnailImage: UIImage?;
    
    init(with dic: [String: Any?]) {
        self.id = dic["id"] as? String;
        self.title = dic["title"] as? String;
        if let id = self.id,
            let secret = dic["secret"] as? String,
            let farm = dic["farm"] as? Int,
            let server = dic["server"] as? String {
            self.imageLink = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg";
        }
    }
    
    func getImage(completionBlock block: (( _ image: UIImage?, _ error: Error?)-> Void)?){
        if let image = self.image {
            block?(image, nil);
        } else {
            guard let link = self.imageLink, !link.isEmpty, let url = URL(string: link) else {
                block?(nil, MyError("Error: Couldn't formulate URL for image."));
                return;
            }
            infoPrint("Image link: \(link)")
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data,
                    let image = UIImage(data: data) {
                    self.image = image;
                    DispatchQueue.main.async {
                        infoPrint("Size of image: \(image.size)")
                        block?(image, nil);
                    }
                } else if let error = error {
                    infoPrint(error.localizedDescription);
                    DispatchQueue.main.async {
                        block?(nil, error);
                    }
                }
            }
            task.resume();
        }
    }
    
    func getThumbnail(completionBlock block: (( _ image: UIImage?, _ error: Error?)-> Void)?){
        if let image = self.thumbnailImage {
            block?(image, nil);
        } else {
            guard let link = thumbnailLink,
                !link.isEmpty,
                let url = URL(string: link) else {
                block?(nil, MyError("Error: Couldn't formulate URL for image."));
                return;
            }
            
            infoPrint("Thumbnail link: \(link)")
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data,
                    let image = UIImage(data: data) {
                    self.thumbnailImage = image;
                    DispatchQueue.main.async {
                        infoPrint("Size of thumbnail: \(image.size)")
                        block?(image, nil);
                    }
                } else if let error = error {
                    infoPrint(error.localizedDescription);
                    DispatchQueue.main.async {
                        block?(nil, error);
                    }
                }
            }
            task.resume();
        }
    }
}
