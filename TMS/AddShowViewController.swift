//
//  AddShowViewController.swift
//  TMS
//
//  Created by Y50 on 27/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import UIKit
import Kingfisher

class AddShowViewController: UIViewController {
    
    var show: Show!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.kf.setImage(with: URL(string: show.poster!)!,
                              placeholder: nil,
                              options: nil,
            progressBlock: { (receivedSize, totalSize) -> () in
                //print("Download Progress: \(receivedSize)/\(totalSize)")
            },
            completionHandler: { (image, error, cacheType, imageURL) -> () in
                //print("Downloaded and set!")
                
            }
        )
    }

    @IBAction func addShowButton(_ sender: AnyObject) {
        Client.sharedInstance.getShowData(show, completionHandlerForGETShowData: { (success, error) in
            performUIUpdatesOnMain({
                if success {
                    print("Show added successfully")
                } else {
                    print(error?.localizedDescription)
                }
            })
        })
    }
}
