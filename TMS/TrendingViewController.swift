//
//  TrendingViewController.swift
//  TMS
//
//  Created by Y50 on 26/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import UIKit
import Kingfisher

class TrendingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getTrendingShows()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func getTrendingShows() {
        activityIndicator.startAnimating()
        Client.sharedInstance.getTrendingShows({ (shows, success, error) in
            performUIUpdatesOnMain({
                if success {
                    self.collectionView.reloadData()
                } else {
                    print(error?.localizedDescription)
                }
                self.activityIndicator.stopAnimating()
            })
        })
    }

}

extension TrendingViewController: UICollectionViewDataSource {
    
    func items() -> [Show] {
        return Client.sharedInstance.shows
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrendingCell
        let item = items()[(indexPath as NSIndexPath).row]
        
        cell.imageView.kf.setImage(with: URL(string: item.thumb!)!,
                                   placeholder: nil,
                                   options: nil,
            progressBlock: { (receivedSize, totalSize) -> () in
                //print("Download Progress: \(receivedSize)/\(totalSize)")
            },
            completionHandler: { (image, error, cacheType, imageURL) -> () in
                //self.imageIndicator.stopAnimating()
            }
        )
        cell.titleLabel.text = item.title
        cell.watchLabel.text = " \(item.watchers!) people watching "
        cell.watchLabel.sizeToFit()
        
        return cell
    }
    
}

extension TrendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.0, height: collectionView.frame.height / 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddShow" {
            
            let vc = segue.destination as! AddShowViewController
            let index = collectionView.indexPath(for: sender as! TrendingCell)
            vc.show = items()[((index as NSIndexPath?)?.row)!]
            
        }
    }
    
}
