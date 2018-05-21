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
    var H_to_W: CGFloat?
    private var image: UIImage?;
    private var thumbnailImage: UIImage?;
    
    init(with dic: [String: Any?]) {
        self.id = dic["id"] as? String;
        self.title = dic["title"] as? String;
        let image = (dic["images"] as? [[String: Any?]])?[0];
        if (image?["type"] as? String == "image/jpeg" || image?["type"] as? String == "image/png") {
            self.imageLink = image?["link"] as? String;
            if let height = image?["height"] as? CGFloat,
                let width = image?["width"] as? CGFloat {
                self.H_to_W = height / width;
            }
        }
    }
    
    func getImage(completionBlock block: (( _ image: UIImage?, _ error: Error?)-> Void)?){
        if let image = self.image {
            block?(image, nil);
        } else {
            guard let link = self.imageLink, !link.isEmpty, let url = URL(string: link) else {
                block?(nil, MyError(msg: "Error: Couldn't formulate URL for image."));
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
            guard let link = imageLink?.replacingOccurrences(of: ".png", with: "s.png").replacingOccurrences(of: ".jpg", with: "s.jpg"),
                !link.isEmpty,
                let url = URL(string: link) else {
                block?(nil, MyError(msg: "Error: Couldn't formulate URL for image."));
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
