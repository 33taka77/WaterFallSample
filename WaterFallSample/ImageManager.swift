//
//  ImageManager.swift
//  PhotosLibTest
//
//  Created by 相澤 隆志 on 2015/03/28.
//  Copyright (c) 2015年 相澤 隆志. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ImageManager {
    
    //let sortByCaptureDate = "creationDate"
    //let sortBylocation = "locationIdentifier"
    
    
    /*
    "Date":"2015/03/22"
    "Camera":"EOS M3"
    "Object": AnyObject as PHAsset
    */
    //private var assetsArray:[Dictionary<String,AnyObject>] = []
    private var assetsArray:[PHAsset] = [PHAsset]()
    //private var sortDictionary:Dictionary<String,AnyObject> = [:]
    private var images:[[AnyObject]] = [[AnyObject]]()
    private var sectionNames:[String] = [String]()
    
    var sectionCount:Int {
        get{
            return sectionNames.count
        }
    }
    var allImageCount:Int {
        get{
            return assetsArray.count
        }
    }
    func getSectionName(index:Int)->String {
        return sectionNames[index]
    }
    
    func getImageArray( sectionName:String )->[PHAsset] {
        let i = find(sectionNames,sectionName)
        let array :[PHAsset] = images[i!] as [PHAsset]
        return array
    }
    func getImageCount( section:Int )->Int {
        var items:[PHAsset] = images[section] as [PHAsset]
        return items.count
    }
    
    func getImageCountInAsset()->Int {
        println("asset count:\(assetsArray.count)")
        return assetsArray.count
    }
    class var sharedInstance:ImageManager {
        struct Static{
            static let instance:ImageManager = ImageManager()
        }
        return Static.instance
    }
    func getAsset(index:Int)->AnyObject {
        let asset = assetsArray[index]
        return asset
    }
    func getAsset(section:Int, index:Int)->AnyObject {
        let array:[PHAsset] = images[section] as [PHAsset]
        return array[index]
    }
    func collectAssets(update: ()->Void) {
        let momentsList:PHFetchResult! = PHCollectionList.fetchCollectionListsWithType(PHCollectionListType.MomentList, subtype: PHCollectionListSubtype.Any, options: nil)
        momentsList.enumerateObjectsUsingBlock { (obj, Index, flag) -> Void in
            let collectionList: PHCollectionList = obj as PHCollectionList
            let moments:PHFetchResult! = PHAssetCollection.fetchMomentsInMomentList(collectionList, options: nil)
            moments.enumerateObjectsUsingBlock { (object, index, flag) -> Void in
                let assets:PHFetchResult! = PHAsset.fetchAssetsInAssetCollection(object as PHAssetCollection, options: nil)
                assets.enumerateObjectsUsingBlock({ (asset, indexOfAsset, flag) -> Void in
                    let tempObj:PHAsset = asset as PHAsset
                    self.assetsArray.append(tempObj)
                    update()
                })
            }
        }
    }
    
    
    func convertDateToString(date:NSDate)->String {
        var date_formatter: NSDateFormatter = NSDateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd"
        let dateString = date_formatter.stringFromDate(date)
        return dateString
    }
    
    /*
    "EOS M3":[Dictionary]
    "iPhone 6":[Dictionary]
    */
    
    func sortByKeyOfAssetDate(){
        for asset in assetsArray {
            let dateString:String = convertDateToString(asset.creationDate)
            if contains(sectionNames, dateString) {
                let i = find(sectionNames, dateString)
                images[i!].append(asset)
            }else{
                var array:[AnyObject] = [AnyObject]()
                sectionNames.append(dateString)
                array.append(asset)
                images.append(array)
            }
        }
    }
    
    
    func GetImageData( item:PHAsset?, size:CGSize )->UIImage {
        var imageData:UIImage! = nil
        //let asset = item["object"] as PHAsset
        
        if(item != nil) {
            let sizeX:CGFloat =  CGFloat(item!.pixelWidth/2)
            let sizeY:CGFloat = CGFloat(item!.pixelHeight/2)
            
            PHImageManager.defaultManager().requestImageForAsset(item!, targetSize: CGSizeMake(sizeX, sizeY), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                imageData = image
            })
        }
        return imageData
    }
    
    
    func GetImage( section: Int, row: Int )->UIImage {
        var items = images[section]
        let item: PHAsset = items[row] as PHAsset
        let imgWidth:CGFloat = CGFloat(item.pixelWidth)
        let imgHeight:CGFloat = CGFloat(item.pixelHeight)
        let size:CGSize = CGSizeMake( imgWidth/2, imgHeight/2 )
        var imagedata:UIImage = self.GetImageData( item , size: size )
        return imagedata
    }
    
    
    func getImageInAsset( row:Int )->UIImage {
        
        let item:PHAsset = assetsArray[row] as PHAsset
        let imgWidth:CGFloat = CGFloat(item.pixelWidth)
        let imgHeight:CGFloat = CGFloat(item.pixelHeight )
        let size:CGSize = CGSizeMake( imgWidth/2, imgHeight/2 )
        var imagedata:UIImage = self.GetImageData( item , size: size )
        return imagedata
    }
    
}
/*
class ImageManager {
    
    //let sortByCaptureDate = "creationDate"
    //let sortBylocation = "locationIdentifier"
    
    
    /*
    "Date":"2015/03/22"
    "Camera":"EOS M3"
    "Object": AnyObject as PHAsset
    */
    private var assetsArray:[Dictionary<String,AnyObject>] = []
    private var sortDictionary:Dictionary<String,AnyObject> = [:]
    private var images:[[AnyObject]] = [[AnyObject]]()
    private var sectionNames:[String] = [String]()
    
    var sectionCount:Int {
        get{
            return sectionNames.count
        }
    }
    func getSectionName(index:Int)->String {
        return sectionNames[index]
    }
    
    func getImageArray( sectionName:String )->[Dictionary<String,AnyObject>] {
        let i = find(sectionNames,sectionName)
        let array :[Dictionary<String,AnyObject>] = images[i!] as [Dictionary<String,AnyObject>]
        return array
    }

    class var sharedInstance:ImageManager {
        struct Static{
            static let instance:ImageManager = ImageManager()
        }
        return Static.instance
    }
    
    func collectAssets(update: ()->Void) {
        let momentsList:PHFetchResult! = PHCollectionList.fetchCollectionListsWithType(PHCollectionListType.MomentList, subtype: PHCollectionListSubtype.Any, options: nil)
        momentsList.enumerateObjectsUsingBlock { (obj, Index, flag) -> Void in
            let collectionList: PHCollectionList = obj as PHCollectionList
            let moments:PHFetchResult! = PHAssetCollection.fetchMomentsInMomentList(collectionList, options: nil)
            moments.enumerateObjectsUsingBlock { (object, index, flag) -> Void in
                let assets:PHFetchResult! = PHAsset.fetchAssetsInAssetCollection(object as PHAssetCollection, options: nil)
                assets.enumerateObjectsUsingBlock({ (asset, indexOfAsset, flag) -> Void in
                    let tempObj:PHAsset = asset as PHAsset
                    var item:Dictionary<String,AnyObject> = [:]
                    item["creationDate"] = tempObj.creationDate
                    item["captureDateString"] = self.convertDateToString(tempObj.creationDate)
                    //item["filename"] = tempObj.filename
                    item["pixelWidth"] = tempObj.pixelWidth
                    item["pixelHeight"] = tempObj.pixelHeight
                    item["locationIdentifier"] = tempObj.localIdentifier
                    item["object"] = asset
                    self.assetsArray.append(item)
                    update()
                })
            }
        }
    }
    
    func convertDateToString(date:NSDate)->String {
        var date_formatter: NSDateFormatter = NSDateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd"
        let dateString = date_formatter.stringFromDate(date)
        return dateString
    }
    
    /*
    "EOS M3":[Dictionary]
    "iPhone 6":[Dictionary]
    */
    func sortByKeyOfAssetDate(){
        let key:String = "captureDateString"
       // var retDict:Dictionary<String,AnyObject> = [:]
        for obj in assetsArray {
            let dict:Dictionary = obj as Dictionary
            for (keyOf, value) in dict {
                if keyOf == key { //keyOf = "Camera"
                    let keyName: String? = value as? String // keyName = "EOS M3"
                    //if let names: AnyObject = sortDictionary[keyName!] {
                    if contains(sectionNames, keyName!) {
                        let i = find(sectionNames, keyName!)
                        images[i!].append(dict)
                        //var array:[AnyObject] = images[i!] as [AnyObject]
                        //array.append(dict)
                        //var newDictArray:[[String:AnyObject]] = names as [[String:AnyObject]]
                        //newDictArray.append(dict)
                    }else{
                        var array:[AnyObject] = [AnyObject]()
                        sectionNames.append(keyName!)
                        array.append(dict)
                        images.append(array)

                        //var array:[[String:AnyObject]] = [[String:AnyObject]]()
                        //sortDictionary[keyName!] = array
                        //var newDictArray:[[String:AnyObject]] = sortDictionary[keyName!] as [[String:AnyObject]]
                        //newDictArray.append(dict)
                    }
                }
            }
        }
    }

    func GetImageData( item:[String:AnyObject], size:CGSize )->UIImage {
        var imageData:UIImage! = nil
        let asset = item["object"] as? PHAsset

        
        if(asset != nil) {
            let sizeX:CGFloat =  CGFloat(asset!.pixelWidth/2)
            let sizeY:CGFloat = CGFloat(asset!.pixelHeight/2)
            
            PHImageManager.defaultManager().requestImageForAsset(asset!, targetSize: CGSizeMake(sizeX, sizeY), contentMode:       PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                imageData = image
            })
        }

        /*
        let asset = item["object"] as PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize:size, contentMode: PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
            imageData = image
        })
        */
        return imageData
    }
}
*/