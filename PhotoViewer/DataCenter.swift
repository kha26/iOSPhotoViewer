//
//  DataCenter.swift
//  PhotoViewer
//
//  Created by Kemal Hasan Atay on 5/21/18.
//  Copyright © 2018 Hasan Atay. All rights reserved.
//

import Foundation

class DataCenter {
    var clientID: String? {
        if let path = Bundle.main.infoDictionary {
            if let clientID = path["imgur Client ID"] as? String {
                infoPrint("Client ID is \(clientID).");
                return clientID;
            } else {
                infoPrint("Client ID not found.")
            }
        }
        return nil;
    }
    
    var clientSecret: String? {
        if let path = Bundle.main.infoDictionary {
            if let clientSecret = path["imgur Client Secret"] as? String {
                infoPrint("Client Secret is \(clientSecret)");
                return clientSecret;
            } else {
                infoPrint("Client Secret not found.")
            }
        }
        return nil;
    }
    
    var baseURL: URL? {
        return URL(string: "https://api.imgur.com/3/gallery/hot?showViral=true&mature=false");
    }
    
    func getPhotos(callback block: (( _ photos: [Photo]?, _ error: Error?) -> Void)?) {
        if let url = baseURL,
            let clientID = clientID {
            let config = URLSessionConfiguration.default;
            config.httpAdditionalHeaders = ["Authorization" : "Client-ID \(clientID)"];
            let session = URLSession(configuration: config);
            let task = session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any];
                        if let dic = json,
                            let photoList = dic["data"] as? [[String : Any?]] {
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
                            block?(nil, MyError(msg: "Error: Cannot access JSON elements."));
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
    init(msg: String) {
        self.msg = msg;
    }
    var localizedDescription: String {
        return self.msg;
    }
}


func infoPrint( _ s: String) {
    let debug = true;
    if debug {
        debugPrint(s);
    }
}
