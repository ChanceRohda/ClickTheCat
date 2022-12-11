//
//  HallOfFameViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 10/30/22.
//

import UIKit
import FirebaseDatabase
import SDWebImage
class HallOfFameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var viewControllerClass: ViewControllerDelegate?
    var topUsers: [HallOfFamerModel] = []
    
    @IBOutlet weak var hallOfFameTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hallOfFameTableView.delegate = self
        hallOfFameTableView.dataSource = self
        Database.database().reference().child("hallOfFame").queryOrdered(byChild: "hof").queryLimited(toLast: 5000).observeSingleEvent(of: .value) { snapshot in
            print(snapshot)
            guard let users = snapshot.value as? [String : Any] else {
                print("users not found")
                return
            }
            
            for user in users {
                guard let userValue = user.value as? [String : Any] else {
                    print("userValue not found")
                    continue
                }
                let userID = user.key
                guard let user = HallOfFamerModel(data: userValue, userKey: userID) else {
                    print("user not found")
                    continue
                }
                print("User Added: \(user)")
                self.topUsers.append(user)
                
            }
            self.topUsers.sort { user1, user2 in
                user1.hof > user2.hof
            }
            self.hallOfFameTableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return topUsers.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardTableViewCell") as! LeaderboardTableViewCell
        let user = topUsers[indexPath.row]
        cell.usernameLabel.text = user.username
        //cell.avatarImageView.sd_setImage(with: user.avatar, placeholderImage: UIImage(systemName: "person.fill")!)
        UserModel.collection.child(user.id).observeSingleEvent(of: .value) { snapshot in
            let user = UserModel(snapshot: snapshot)
            cell.avatarImageView.sd_setImage(with: user?.avatar)
        }
        cell.coinsLabel.text = "Hall of Fame x\(user.hof)"
        
        
        
        
        return cell
    }

    @IBAction func infoButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Hall of Fame", message: "Reach 1 Quintillion coins to enter the Hall of Fame!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
