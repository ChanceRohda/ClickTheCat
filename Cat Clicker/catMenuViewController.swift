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
    
    

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    weak var viewControllerClass: ViewControllerDelegate?
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
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let catItem = acquiredCats[indexPath.row]
       viewControllerClass?.changeSelectedCat(cat: Cat(name: catItem.name, description: catItem.description, image: catItem.image))
       
   }

    @IBAction func enterCodeButtonDidTouch(_ sender: Any) {
        var code: String = codeTextField.text ?? "CatClick"
        var catList = viewControllerClass?.getCatList()
        if code == "1033" && !catList!.contains(where: { cat in
            return cat.name == "Cat Food Cat"
        }){
            viewControllerClass?.addCat(cat: Cat(name: "Cat Food Cat", description: "Cat Food Upgrades +Autocoin", image: UIImage(named: "Cat Food Cat")!))
            acquiredCats = (viewControllerClass?.getCatList())!
            tableView.reloadData()
            codeTextField.text = ""
        } else if code == "2022" && !catList!.contains(where: { cat in
            return cat.name == "Gold Cat"
        }){
            viewControllerClass?.addCat(cat: Cat(name: "Gold Cat", description: "Ads Give More Gold", image: UIImage(named: "Gold Cat")!))
            acquiredCats = (viewControllerClass?.getCatList())!
            tableView.reloadData()
            codeTextField.text = ""
            
            
        } else {
            let alert = UIAlertController(title: "Nope!", message: "That's not a valid code.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
