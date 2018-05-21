//
//  ListCell.swift
//  PhotoViewer
//
//  Created by Kemal Hasan Atay on 5/21/18.
//  Copyright © 2018 Hasan Atay. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet weak var imgPhoto: UIImageView!;
    @IBOutlet weak var lblTitle: UILabel!
    
    var id: String?;
    
    static var padding: CGFloat = 8;
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.imgPhoto.image = nil;
    }
}
