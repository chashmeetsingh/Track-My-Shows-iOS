//
//  EpisodeDetailViewController.swift
//  TMS
//
//  Created by Y50 on 30/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import UIKit
import RealmSwift
import Toaster

class EpisodeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watched: UISwitch!
    @IBOutlet weak var overview: UITextView!
    var episode: Episode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.kf.setImage(with: URL(string: episode.banner!)!,
                              placeholder: nil,
                              options: nil,
                              progressBlock: { (receivedSize, totalSize) -> () in
                                //print("Download Progress: \(receivedSize)/\(totalSize)")
            },
                              completionHandler: { (image, error, cacheType, imageURL) -> () in
                                //self.imageIndicator.stopAnimating()
            }
        )
        
        overview.text = episode.overview
        if episode.watched {
            watched.isOn = true
        } else {
            watched.isOn = false
        }
        
        self.navigationItem.title = episode.episodeTitle
    }

    
    @IBAction func setWatchStatus(_ sender: AnyObject) {
        let sender = sender as? UISwitch
        
        performDatabaseOperations({
            
            let realm = try! Realm()
            
            do {
                try realm.write() {
                    if (sender?.isOn)! {
                        self.episode.watched = true
                    } else {
                        self.episode.watched = false
                    }
                }
                Toast(text: "Successfully updated").show()
            } catch let error {
                Toast(text: error.localizedDescription).show()
            }
        })
        
    }

}
