//
//  ProjectViewCell.swift
//  MKUp
//
//  Created by Alexandre barbier on 22/11/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

class ProjectViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = UIColor.MKWhiteColor()
    }
}
