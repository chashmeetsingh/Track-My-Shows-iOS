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
    var shows: Results<Show>!
    
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        getSavedShows()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        let holdToDelete = UILongPressGestureRecognizer(target: self, action: #selector(longPressDelete(sender:)))
        holdToDelete.minimumPressDuration = 1.00
        self.collectionView.addGestureRecognizer(holdToDelete)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set(self.tabBarController?.selectedIndex, forKey: "index")
        UserDefaults.standard.synchronize()
    }
    
    func longPressDelete(sender: UILongPressGestureRecognizer) {
        
        let p = sender.location(in: collectionView)
        
        let indexPath = self.collectionView.indexPathForItem(at: p)
        if (indexPath == nil) {
        } else if (sender.state == UIGestureRecognizerState.began) {
            
            let alert = UIAlertController(title: "Confirm", message: "Are you sure to delete?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { action in
                performDatabaseOperations {
                    let realm = try! Realm()
                    try! realm.write() {
                        realm.delete(self.shows[indexPath!.row].episodes)
                        realm.delete(self.shows[indexPath!.row])
                    }
                    self.getSavedShows()
                }
            }))
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        } 
    }
    
    func reloadData(notification: NSNotification) {
        getSavedShows()
    }
    
    func getSavedShows() {
        let realm = try! Realm()
        shows = realm.objects(Show.self)
        if shows.count == 0 {
            defaultLabel.isHidden = false
        } else {
            defaultLabel.isHidden = true
        }
        collectionView.reloadData()
    }
    
}

extension ShowsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ShowTabCell
        let item = shows[(indexPath as NSIndexPath).row]

        cell.showTitle.text = item.title
        cell.showTitle.isHidden = false
        
        cell.bannerImageView.kf.setImage(with: URL(string: item.banner!)!,
                                         placeholder: nil,
                                         options: nil,
            progressBlock: { (receivedSize, totalSize) -> () in
                //print("Download Progress: \(receivedSize)/\(totalSize)")
            },
            completionHandler: { (image, error, cacheType, imageURL) -> () in
                //self.imageIndicator.stopAnimating()
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    cell.bannerImageView.isHidden = false
                    cell.showTitle.isHidden = true
                }
            }
        )
        
        return cell
    }
    
}

extension ShowsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height / 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    
}

extension ShowsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y > 0) {
            UIView.animate(withDuration: 0.4, animations: {
                self.addButton.isHidden = true
            })
        } 
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.4, animations: {
            self.addButton.isHidden = false
        })
    }
    
}
