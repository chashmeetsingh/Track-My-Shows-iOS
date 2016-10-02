//
//  UpcomingViewController.swift
//  TMS
//
//  Created by Y50 on 29/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class UpcomingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var defaultLabel: UILabel!

    var upcoming: Results<Episode>!

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
        let later = today.addingTimeInterval(60 * 60 * 24 * 30)

        upcoming = allEpisodes.filter("firstAired BETWEEN {%@, %@} AND number > 0", today, later)
            .sorted(byProperty: "firstAired", ascending: true)

        if upcoming.count == 0 {
            defaultLabel.isHidden = false
        } else {
            defaultLabel.isHidden = true
        }

        self.collectionView.reloadData()
    }

}

extension UpcomingViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcoming.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EpisodeViewCell
        let item = upcoming[indexPath.item]

        let episodeDate = timeAhead(to: item.firstAired!, numericDates: true)

        let seasonDetails = "S\(String(format: "%02d", item.season.number))E\(String(format: "%02d", item.number))"

        cell.imageView.kf.setImage(with: URL(string: (item.season.show?.poster)!)!,
                                   placeholder: nil,
                                   options: nil,
                                   progressBlock: { (receivedSize, totalSize) -> () in
                                    //print("Download Progress: \(receivedSize)/\(totalSize)")
            },
                                   completionHandler: { (image, error, cacheType, imageURL) -> () in
                                    //print("Downloaded and set!")
                                    cell.activityIndicator1.stopAnimating()
            }
        )

        cell.episodeTitle.text = seasonDetails + " - " + item.title!
        cell.timeAgo.text = episodeDate
        cell.showTitle.text = item.season.show?.title

        return cell
    }

}

/// UITableViewDelegate methods.
extension UpcomingViewController: UICollectionViewDelegate {

    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailEpisode" {
            let vc = segue.destination as! EpisodeDetailViewController
            let index = collectionView.indexPath(for: sender as! EpisodeViewCell)
            vc.episode = upcoming[(index?.row)!]
        }
    }
}
