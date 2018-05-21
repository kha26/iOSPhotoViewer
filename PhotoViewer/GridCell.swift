//
//  GridCell.swift
//  PhotoViewer
//
//  Created by Kemal Hasan Atay on 5/21/18.
//  Copyright © 2018 Hasan Atay. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {
    @IBOutlet weak var imgPhoto: UIImageView!
    var id: String?
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.imgPhoto.image = nil;
    }
}
