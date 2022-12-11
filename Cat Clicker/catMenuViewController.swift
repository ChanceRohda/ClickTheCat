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
    var tap: UITapGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        acquiredCats = (viewControllerClass?.getCatList())!
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardAppeared), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func keyboardAppeared() {
        view.addGestureRecognizer(tap!)
    }
    @objc func keyboardDisappeared() {
        view.removeGestureRecognizer(tap!)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
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
       print("tapped")
       
       let catItem = acquiredCats[indexPath.row]
       viewControllerClass?.changeSelectedCat(cat: catItem)
       let alert = UIAlertController(title: "Cat selected!", message: "You selected a cat!", preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default) { action in
           alert.dismiss(animated: true, completion: nil)
       }
       alert.addAction(okAction)
       present(alert, animated: true, completion: nil)
   }

    @IBAction func infoButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Cat Collection", message: "Here are your cats! Click one to select it and use its effect.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
            let alert = UIAlertController(title: "Cool!", message: "You got a cat!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else if code == "2022" && !catList!.contains(where: { cat in
            return cat.name == "Gold Cat"
        }){
            viewControllerClass?.addCat(cat: Cat(name: "Gold Cat", description: "Ads Give More Gold", image: UIImage(named: "Gold Cat")!))
            acquiredCats = (viewControllerClass?.getCatList())!
            tableView.reloadData()
            codeTextField.text = ""
            let alert = UIAlertController(title: "Cool!", message: "You got a cat!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            
        } else if code == "1031" && !catList!.contains(where: { cat in
            return cat.name == "Cat-O-Lantern"
        }){
            viewControllerClass?.addCat(cat: Cat(name: "Cat-O-Lantern", description: "x2 CpC with a scary twist!", image: UIImage(named: "Cat-O-Lantern")!))
            acquiredCats = (viewControllerClass?.getCatList())!
            tableView.reloadData()
            codeTextField.text = ""
            let alert = UIAlertController(title: "Cool!", message: "You got a cat!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            
        } else if code == "4632" && !catList!.contains(where: { cat in
            return cat.name == "Salak Cat"
        }){
            viewControllerClass?.addCat(cat: Cat(name: "Salak Cat", description: "More Tuna from Crates!", image: UIImage(named: "Salak Cat")!))
            acquiredCats = (viewControllerClass?.getCatList())!
            tableView.reloadData()
            codeTextField.text = ""
            let alert = UIAlertController(title: "Cool!", message: "You got a cat!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            
        } else {
            let alert = UIAlertController(title: "Nope!", message: "Not a valid code.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
