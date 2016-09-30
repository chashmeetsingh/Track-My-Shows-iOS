//
//  AiredViewController.swift
//  TMS
//
//  Created by Y50 on 29/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import UIKit
import RealmSwift

class AiredViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var defaultLabel: UILabel!
    
    var aired: Results<Episode>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        prepareItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set(self.tabBarController?.selectedIndex, forKey: "index")
        UserDefaults.standard.synchronize()
    }
    
    func reloadData(notification: NSNotification) {
        prepareItems()
    }
    
    private func prepareItems() {
        
        let realm = try! Realm()
        let allEpisodes = realm.objects(Episode.self)
        
        let today = NSDate()
        let earlier = today.addingTimeInterval(60 * 60 * 24 * 30 * -1)
        
        aired = allEpisodes.filter("airDateTime BETWEEN {%@, %@} AND seasonNumber > 0", earlier, today)
            .sorted(byProperty: "airDateTime", ascending: false)
        
        if aired.count == 0 {
            defaultLabel.isHidden = false
        } else {
            defaultLabel.isHidden = true
        }
        
        collectionView.reloadData()
    }

}

extension AiredViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aired.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EpisodeViewCell
        let item = aired[indexPath.item]

        let episodeDate = timeSince(from: item.airDateTime! as NSDate, numericDates: true)
        let seasonDetails = "S\(String(format: "%02d", item.seasonNumber))E\(String(format: "%02d", item.episodeNumber))"
        
        cell.imageView.kf.setImage(with: URL(string: (item.show?.poster)!)!,
                                   placeholder: nil,
                                   options: nil,
                                     progressBlock: { (receivedSize, totalSize) -> () in
                                        //print("Download Progress: \(receivedSize)/\(totalSize)")
            },
                                     completionHandler: { (image, error, cacheType, imageURL) -> () in
                                        //print("Downloaded and set!")
                                        cell.activityIndicator.stopAnimating()
                                        
            }
        )
        
        cell.episodeTitle.text = seasonDetails + " - " + item.episodeTitle!
        cell.timeAgo.text = episodeDate
        cell.showTitle.text = item.show?.title
        
        return cell
    }
    
}

/// UITableViewDelegate methods.
extension AiredViewController: UICollectionViewDelegate {
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
}
