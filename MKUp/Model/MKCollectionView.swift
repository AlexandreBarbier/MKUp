//
//  MKCollectionView.swift
//  MKUp
//
//  Created by Alexandre barbier on 03/02/15.
//  Copyright (c) 2015 Alexandre barbier. All rights reserved.
//

import UIKit

class MKCollectionView: MKView {
    var collectionView :UICollectionView?
    
    var delegate : protocol <UICollectionViewDelegate, UICollectionViewDataSource>? {
        didSet {
            collectionView!.delegate = self.delegate
            collectionView!.dataSource = self.delegate
        }
    } 
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        self.collectionView = self.getMainSubview()
        self.collectionView!.removeFromSuperview()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.userInteractionEnabled = false
        collectionView!.registerNib(UINib(nibName: "MKCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(collectionView!)
        self.collectionView!.delegate = self.delegate
        self.collectionView!.dataSource = self.delegate
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
      
        super.encodeWithCoder(aCoder) 
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView!.registerNib(UINib(nibName: "MKCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.userInteractionEnabled = false
        collectionView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(collectionView!)
    }
}
