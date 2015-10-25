//
//  MemeCollectionViewCell.swift
//  Meme Me
//
//  Created by Victor Guthrie on 10/10/15.
//  Copyright © 2015 Victor Guthrie. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    var memeImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        memeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        contentView.addSubview(memeImage)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
