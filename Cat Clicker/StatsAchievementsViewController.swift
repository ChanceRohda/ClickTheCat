//
//  StatsAchievementsViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 7/18/22.
//

import UIKit







class StatsAchievementsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalClicksLabel: UILabel!
    @IBOutlet weak var adsWatchedLabel: UILabel!
    @IBOutlet weak var catsEarnedLabel: UILabel!
    @IBOutlet weak var achievementInfoLabel: UILabel!
    weak var viewControllerClass: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var adsWatched: Int = (viewControllerClass?.getAdPoints())!
        adsWatchedLabel.text = "Ads Watched: \(adsWatched)"
        collectionView.dataSource = self
        collectionView.delegate = self
        var catsEarned: Int = (viewControllerClass?.getCatList().count)!
        catsEarnedLabel.text = "Cats Earned: \(catsEarned)"
        // Do any additional setup after loading the view.
        var clicks: Int = (viewControllerClass?.getTotalClicks())!
        totalClicksLabel.text = "Total Clicks: \(clicks)"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewControllerClass?.getAchievements().count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = view.frame.width
        return CGSize(width: screenWidth/3.2, height: screenWidth/3.2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var achievements = viewControllerClass?.getAchievements()
        let achievement = achievements![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCollectionViewCell", for: indexPath) as! AchievementCollectionViewCell
        if achievement.isComplete == false {
            cell.achievementImageView.image = UIImage(systemName: "questionmark.square.fill")
        } else {
            cell.achievementImageView.image = achievement.completedImage
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var achievements = viewControllerClass?.getAchievements()
        achievementInfoLabel.text = achievements![indexPath.row].description
    }
        
    
    
    
    

 
}
