//
//  SearchViewController.swift
//  TMS
//
//  Created by Y50 on 29/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import UIKit
import Toaster

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noShowLabel: UILabel!

    var shows = [Show]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        noShowLabel.isHidden = true
    }

}

extension SearchViewController: UICollectionViewDataSource {

    func items() -> [Show] {
        return shows
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchShowCell
        let item = items()[indexPath.row]

        cell.showTitle.text = item.title
        cell.showTitle.isHidden = false

        if let banner = URL(string: item.banner!) {
            cell.imageView.kf.setImage(with: banner,
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
                                            cell.imageView.isHidden = false
                                            cell.showTitle.isHidden = true
                                        }
                }
            )
        } else {
            cell.imageView.image = UIImage()
        }

        return cell
    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        shows = []
        collectionView.reloadData()
    }

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        activityIndicator.startAnimating()
//        noShowLabel.isHidden = true
//        _ = Client.sharedInstance.getShowsByName(searchBar.text!, completionHandlerForGETShowByName: { (data, success, error) in
//            performUIUpdatesOnMain({
//                if success {
//                    self.shows = data!
//                    self.collectionView.reloadData()
//                } else {
//                    Toast(text: error?.localizedDescription).show()
//                }
//                self.activityIndicator.stopAnimating()
//                if data?.count == 0 {
//                    self.noShowLabel.isHidden = false
//                } else {
//                    self.noShowLabel.isHidden = true
//                }
//            })
//        })
//    }

}

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddShow" {
            let vc = segue.destination as! AddShowViewController
            let index = self.collectionView.indexPath(for: sender as! SearchShowCell)
            vc.show = self.items()[((index as NSIndexPath?)?.row)!]
        }
    }

}
