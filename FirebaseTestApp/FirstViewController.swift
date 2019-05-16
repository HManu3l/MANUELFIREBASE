//
//  FirstViewController.swift
//  FirebaseTestApp
//
//  Created by developer on 5/9/19.
//  Copyright © 2019 napify. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper

class FirstViewController: UIViewController {
    
    @IBOutlet weak var nameFieldOne: UITextField!
    @IBOutlet weak var clasificationFieldOne: UITextField!
    @IBOutlet weak var usesFieldOne: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let FirebaseReference = Database.database().reference()
    
    var ref: DatabaseReference!
    var models = [ModelOne]()
    var databaseHandle: DatabaseHandle?
    var selectedModel = ModelOne()
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
    //Si quieres cambiar que la tabla en firebase se llame diferente hay que cambiar estos campos
    //donde dice CrudPrincipal, y ponemos el nombre como quieras que se llame tu tabla
    // Para modificar los datos le das tap a la celda y modificas cualquiera de los campos
    // y se actualizan, lo unico que faltaba es que en la celda mostraramos los 3 datos ya que solo mostramos el
    // primero
    
    func getData() {
        FirebaseReference.child("Guia de Reciclaje").observe(.childAdded, with:  { (snapshot) in
            var data = snapshot.value as! [String:Any]
            data["id"] = snapshot.key
            if let data = Mapper<ModelOne>().map(JSON: data) {
                self.models.insert(data, at: 0)
                self.tableView.reloadData()
            }
        })
    }
    
    func removeObjectFromFirebase(model: ModelOne) {
        FirebaseReference.child("Guia de Reciclaje").child(model.id).removeValue()
    }
    
    func updateData() {
        if nameFieldOne.text != "" && clasificationFieldOne.text != "" && usesFieldOne.text != "" {
            FirebaseReference.child("Guia de Reciclaje").child(selectedModel.id).setValue(["Place": nameFieldOne.text, "Location": clasificationFieldOne.text, "Recycling": usesFieldOne.text])
            models[selectedIndex].place = nameFieldOne.text ?? ""
            models[selectedIndex].location = clasificationFieldOne.text ?? ""
            models[selectedIndex].recycling = usesFieldOne.text ?? ""
            nameFieldOne.text = ""
            clasificationFieldOne.text = ""
            usesFieldOne.text = ""
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
            if nameFieldOne.text != "" && clasificationFieldOne.text != "" && usesFieldOne.text != "" {
                FirebaseReference.child("Guia de Reciclaje").childByAutoId().setValue(["Place": nameFieldOne.text, "Location": clasificationFieldOne.text, "Recycling": usesFieldOne.text])
                nameFieldOne.text = ""
                clasificationFieldOne.text = ""
                usesFieldOne.text = ""
            } else {
                print("Missing fields")
            }
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        isEditingData = false
        cancelButton.isHidden = true
        nameFieldOne.text = ""
        clasificationFieldOne.text = ""
        usesFieldOne.text = ""
    }
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.identifier, for: indexPath) as? GeneralTableViewCell {
            cell.titleLabel.text = models[indexPath.row].place
            cell.locationLabel.text = models[indexPath.row].location
            cell.recyclingLabel.text = models[indexPath.row].recycling
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
        nameFieldOne.text = selectedModel.place
        clasificationFieldOne.text = selectedModel.location
        usesFieldOne.text = selectedModel.recycling
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            removeObjectFromFirebase(model: models[indexPath.row])
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}
