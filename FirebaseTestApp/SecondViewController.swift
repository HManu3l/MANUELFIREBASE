//
//  SecondViewController.swift
//  FirebaseTestApp
//
//  Created by developer on 5/9/19.
//  Copyright © 2019 napify. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper

class SecondViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var reusableText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let FirebaseReference = Database.database().reference()
    
    var ref: DatabaseReference!
    var models = [ModelTwo]()
    var databaseHandle: DatabaseHandle?
    var selectedModel = ModelTwo()
    var selectedIndex = Int()
    var isEditingData = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: GeneralTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: GeneralTableViewCell.identifier)
        getData()
    }
    
    func getData() {
        FirebaseReference.child("Sitios sucios del estado").observe(.childAdded, with:  { (snapshot) in
            var data = snapshot.value as! [String:Any]
            data["id"] = snapshot.key
            if let data = Mapper<ModelTwo>().map(JSON: data) {
                self.models.insert(data, at: 0)
                self.tableView.reloadData()
            }
        })
    }
    
    func removeObjectFromFirebase(model: ModelTwo) {
        FirebaseReference.child("Sitios sucios del estado").child(model.id).removeValue()
    }
    
    func updateData() {
        if nameField.text != "" && reusableText.text != "" {
            FirebaseReference.child("Sitios sucios del estado").child(selectedModel.id).setValue(["Name": nameField.text, "Reusable": reusableText.text])
            models[selectedIndex].name = nameField.text ?? ""
            models[selectedIndex].reusable = reusableText.text ?? ""
            nameField.text = ""
            reusableText.text = ""
            isEditingData = false
            cancelButton.isHidden = true
            tableView.reloadData()
        } else {
            print("Missing fields")
        }
    }
    
    @IBAction func posData(_ sender: Any) {
        if isEditingData {
            updateData()
        } else {
            if nameField.text != "" && reusableText.text != "" {
                FirebaseReference.child("Sitios sucios del estado").childByAutoId().setValue(["Name": nameField.text, "Reusable": reusableText.text])
                nameField.text = ""
                reusableText.text = ""
            } else {
                print("Missing fields")
            }
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        isEditingData = false
        cancelButton.isHidden = true
        nameField.text = ""
        reusableText.text = ""
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.identifier, for: indexPath) as? GeneralTableViewCell {
            cell.titleLabel.text = models[indexPath.row].name
            cell.locationLabel.text = models[indexPath.row].reusable
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isEditingData = true
        cancelButton.isHidden = false
        selectedModel = models[indexPath.row]
        selectedIndex = indexPath.row
        nameField.text = selectedModel.name
        reusableText.text = selectedModel.reusable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            removeObjectFromFirebase(model: models[indexPath.row])
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

