//
//  ShowsViewController.swift
//  TMS
//
//  Created by Y50 on 26/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class ShowsViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var shows: Results<Show>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        getSavedShows()
    }
    
    func getSavedShows() {
        let realm = try! Realm()
        shows = realm.objects(Show.self)
    }
    
}

extension ShowsViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ShowTabCell
        let item = shows[indexPath.row]
        
        cell.showTitle.text = item.title
        cell.showTitle.hidden = false
        //cell.bannerImageView.hidden = true
        cell.bannerImageView.kf_setImageWithURL(
            NSURL(string: item.banner!)!,
            placeholderImage: nil,
            optionsInfo: nil,
            progressBlock: { (receivedSize, totalSize) -> () in
                //print("Download Progress: \(receivedSize)/\(totalSize)")
            },
            completionHandler: { (image, error, cacheType, imageURL) -> () in
                //self.imageIndicator.stopAnimating()
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    cell.bannerImageView.hidden = false
                    cell.showTitle.hidden = true
                }
            }
        )
        
        return cell
    }
    
}

extension ShowsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 8.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    
}