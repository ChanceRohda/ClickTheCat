//
//  LeaderboardViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/11/22.
//

import UIKit
import FirebaseDatabase
class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var viewControllerClass: ViewControllerDelegate?
    var topUsers: [UserModel] = []
    var place: Int = 1
    @IBOutlet weak var leaderboardTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        place = 1
        
        Database.database().reference().child("users").queryOrdered(byChild: "coins").queryLimited(toLast: 50).observeSingleEvent(of: .value) { snapshot in
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
                guard let user = UserModel(data: userValue, userKey: userID) else {
                    print("user not found")
                    continue
                }
                print("User Added: \(user)")
                self.topUsers.append(user)
                
            }
            self.topUsers.sort { user1, user2 in
                user1.coins > user2.coins
            }
            self.leaderboardTableView.reloadData()
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
        cell.usernameLabel.text = "\(indexPath.row + 1). \(user.username)"
        //"\(place). \(user.username)"
        //place += 1
        
        cell.avatarImageView.sd_setImage(with: user.avatar, placeholderImage: UIImage(systemName: "person.fill")!)
        let roundedAndAbbreviated = viewControllerClass?.roundAndAbbreviate(num: Double(user.coins))
        cell.coinsLabel.text = "Coins: \(roundedAndAbbreviated ?? "0")"
        
        
        
        
        return cell
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
