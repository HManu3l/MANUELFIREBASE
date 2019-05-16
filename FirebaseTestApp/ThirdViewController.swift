//
//  ThirdViewController.swift
//  FirebaseTestApp
//
//  Created by developer on 5/9/19.
//  Copyright © 2019 napify. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper

class ThirdViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var clasificationField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let FirebaseReference = Database.database().reference()
    
    var ref: DatabaseReference!
    var models = [ModelThird]()
    var databaseHandle: DatabaseHandle?
    var selectedModel = ModelThird()
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
        FirebaseReference.child("Centros de Reciclaje").observe(.childAdded, with:  { (snapshot) in
            var data = snapshot.value as! [String:Any]
            data["id"] = snapshot.key
            if let data = Mapper<ModelThird>().map(JSON: data) {
                self.models.insert(data, at: 0)
                self.tableView.reloadData()
            }
        })
    }
    
    func removeObjectFromFirebase(model: ModelThird) {
        FirebaseReference.child("Centros de Reciclaje").child(model.id).removeValue()
    }
    
    func updateData() {
        if nameField.text != "" && clasificationField.text != "" && typeField.text != "" {
            FirebaseReference.child("Centros de Reciclaje").child(selectedModel.id).setValue(["Name": nameField.text, "ClasificationOf": clasificationField.text, "TypeOfData": typeField.text])
            models[selectedIndex].name = nameField.text ?? ""
            models[selectedIndex].type = typeField.text ?? ""
            models[selectedIndex].clasification = clasificationField.text ?? ""
            nameField.text = ""
            clasificationField.text = ""
            typeField.text = ""
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
            if nameField.text != "" && clasificationField.text != "" && typeField.text != "" {
                FirebaseReference.child("Centros de Reciclaje").childByAutoId().setValue(["Name": nameField.text, "ClasificationOf": clasificationField.text, "TypeOfData": typeField.text])
                nameField.text = ""
                clasificationField.text = ""
                typeField.text = ""
            } else {
                print("Missing fields")
            }
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        isEditingData = false
        cancelButton.isHidden = true
        nameField.text = ""
        clasificationField.text = ""
        typeField.text = ""
    }
}

extension ThirdViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.identifier, for: indexPath) as? GeneralTableViewCell {
            cell.titleLabel.text = models[indexPath.row].name
            cell.locationLabel.text = models[indexPath.row].type
            cell.recyclingLabel.text = models[indexPath.row].clasification
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
        clasificationField.text = selectedModel.clasification
        typeField.text = selectedModel.type
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            removeObjectFromFirebase(model: models[indexPath.row])
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}
