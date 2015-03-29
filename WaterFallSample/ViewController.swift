//
//  ViewController.swift
//  WaterFallSample
//
//  Created by 相澤 隆志 on 2015/03/29.
//  Copyright (c) 2015年 相澤 隆志. All rights reserved.
//


//import foundation
import UIKit
import Photos

class ViewController: UIViewController,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var imageManager:ImageManager!

    var cellSizes:[CGSize] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout:CHTCollectionViewWaterfallLayout! = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(2,2,2,2)
        layout.minimumColumnSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.columnCount = 2
        
        imageManager = ImageManager.sharedInstance
        imageManager.collectAssets(update)
        //setupSize()
    }

    func setupSize() {
        for var i = 0; i < imageManager.allImageCount; i++ {
            //let size:CGSize = CGSizeMake(arc4random() % 50+50, arc4random() % 50+50)
            let width:CGFloat = CGFloat(arc4random() % 50+50)
            let asset:PHAsset = imageManager.getAsset(i) as PHAsset
            let imgWidth:CGFloat = CGFloat(asset.pixelWidth)
            let imgHeight:CGFloat = CGFloat(asset.pixelHeight)
            
            let height:CGFloat = width*imgHeight/imgWidth
            let size:CGSize = CGSizeMake(width, height)
            cellSizes.append(size)
        }
    }
    func update() {
        self.collectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        setupSize()
        return imageManager.allImageCount
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:WaterFallCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("MainCollectionCell", forIndexPath: indexPath) as WaterFallCollectionViewCell

        let asset:PHAsset = imageManager.getAsset(indexPath.row) as PHAsset
        let imgWidth:CGFloat = CGFloat(asset.pixelWidth)
        let imgHeight = CGFloat(asset.pixelHeight)
        let sizeX:CGFloat =  CGFloat(asset.pixelWidth/2)
        let sizeY:CGFloat = CGFloat(asset.pixelHeight/2)
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(sizeX, sizeY), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
            cell.imageView.image = image
        })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size:CGSize = cellSizes[indexPath.item]
        return size
    }
    
    

}

