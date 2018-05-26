//
//  DataCenter.swift
//  PhotoViewer
//
//  Created by Kemal Hasan Atay on 5/21/18.
//  Copyright © 2018 Hasan Atay. All rights reserved.
//

import Foundation

class DataCenter {
    var API_Key: String? {
        if let path = Bundle.main.infoDictionary {
            if let clientID = path["flickr key"] as? String {
                infoPrint("flickr key is \(clientID).");
                return clientID;
            } else {
                infoPrint("flickr key not found.")
            }
        }
        return nil;
    }
    
    // I found a photo gallery on Flickr, this is the id
    var gallery_id: String = "66911286-72157693718156901";
    
    var baseURLString: String {
        return "https://api.flickr.com/services/rest/?";
    }
    
    func getPhotos(callback block: (( _ photos: [Photo]?, _ error: Error?) -> Void)?) {
        guard var comps = URLComponents(string: baseURLString), let API_Key = self.API_Key else {
            block?(nil, MyError("Error: Could not initialize URL Components."));
            return;
        }
        let params = ["format" : "json",
                      "nojsoncallback" : "1",
                      "api_key" : API_Key,
                      "method" : "flickr.galleries.getPhotos",
                      "gallery_id" : gallery_id];
        comps.queryItems = [];
        for (key, value) in params {
            comps.queryItems?.append(URLQueryItem(name: key, value: value));
        }
        if let url = comps.url {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any];
                        if let dic = json,
                            let photos = dic["photos"] as? [String : Any?],
                            let photoList = photos["photo"] as? [[String: Any?]] {
                            var photos = [Photo]();
                            for photoJson in photoList {
                                let p = Photo(with: photoJson);
                                if (p.imageLink != nil) {
                                    photos.append(p);
                                }
                            }
                            block?(photos, nil);
                        } else {
                            infoPrint("Error: Cannot access JSON elements.")
                            block?(nil, MyError("Error: Cannot access JSON elements."));
                        }
                    } catch let error as NSError {
                        infoPrint(error.localizedDescription);
                        block?(nil, error);
                    }
                } else {
                    infoPrint(error?.localizedDescription ?? "Error: Didn't receieve an error. Something's up.");
                    block?(nil, error);
                }
            }
            task.resume();
        } else {
            infoPrint("Error: Couldn't find base URL or Client ID.");
        }
    }
}

class MyError: Error {
    private var msg: String
    init( _ msg: String) {
        self.msg = msg;
    }
    var localizedDescription: String {
        return self.msg;
    }
}

var debug = false;
func infoPrint( _ s: String) {
    if debug {
        debugPrint(s);
    }
}
