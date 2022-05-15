//
//  catMenuViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 5/11/22.
//

import UIKit

struct Cat {
    var name: String
    var description: String
    var image: UIImage
}

class catMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var acquiredCats: [Cat] = []
    
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catItem = acquiredCats[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatTableViewCell", for: indexPath) as! CatTableViewCell
        cell.catImageView.image = catItem.image
        cell.catNameLabel.text = catItem.name
        cell.catDescriptionLabel.text = catItem.description
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acquiredCats.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 204
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
