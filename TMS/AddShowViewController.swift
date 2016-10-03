//
//  AddShowViewController.swift
//  TMS
//
//  Created by Y50 on 27/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift
import Toaster

class AddShowViewController: UIViewController {

    var show: Show!

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var checkShow: Results<Show>!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        checkIfShowAlreadySaved()
    }

    func configureView() {
        if let poster = show.poster {
            imageView.kf.setImage(with: URL(string: poster),
                placeholder: nil,
                options: nil,
                progressBlock: { (receivedSize, totalSize) -> () in
                    //print("Download Progress: \(receivedSize)/\(totalSize)")
                },
                completionHandler: { (image, error, cacheType, imageURL) -> () in
                    //print("Downloaded and set!")

                }
            )
        } else {
            imageView.image = UIImage()
        }

        yearLabel.text = "\(show.year)"
        statusLabel.text = show.status
        textView.text = show.overview
    }

    func checkIfShowAlreadySaved() {
        let realm = try! Realm()
        checkShow = realm.objects(Show.self).filter("id = \(show.id)")

        if checkShow.count == 0 {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }

    @IBAction func addShowButton(_ sender: AnyObject) {
        addButton.isEnabled = false
        Toast(text: "Show will be added to list shortly").show()
        Client.sharedInstance.getSeasons(show, completionHandlerForGETShowData: { (success, error) in
            performUIUpdatesOnMain({
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                } else {
                    self.addButton.isEnabled = true
                    print(error?.localizedDescription)
                    Toast(text: error?.localizedDescription).show()
                }
            })
        })
    }
}
