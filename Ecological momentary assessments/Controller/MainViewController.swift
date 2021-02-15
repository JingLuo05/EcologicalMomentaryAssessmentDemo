//
//  ViewController.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/4.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    var name = String()
    var age = Int()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    
    @IBAction func userNameBegin(_ sender: UITextField) {
        print("User name begin")
    }
    
    @IBAction func userNameEnd(_ sender: UITextField) {
        self.name = String(nameTextField.text ?? "404")
        nameTextField.endEditing(true)
        
        //set default name
        let defauls = UserDefaults.standard
        defauls.set(self.name, forKey: UserDefault.id)
    }
    
    @IBAction func ageEditingBegin(_ sender: UITextField) {
        print("age editing begins")
        //ageTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    
    
    @IBAction func ageEnd(_ sender: UITextField) {
        self.age = Int(ageTextField.text!) ?? 0
        ageTextField.endEditing(true)
        print("age editing ends")
        
        //set default age
        let defauls = UserDefaults.standard
        defauls.set(self.age, forKey: UserDefault.age)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2243741453, green: 0.2615192533, blue: 0.4102925658, alpha: 1)
        self.hideKeyboardWhenTappedAround()
        
        //set delegate
        nameTextField.delegate = self
        ageTextField.delegate = self
        
        //get user id and age
        let defaults = UserDefaults.standard
        if let userID = defaults.string(forKey: UserDefault.id) {
            print("user ID: \(userID)") // Some String Value
            nameTextField.text = userID
        }
        if let userAge = defaults.string(forKey: UserDefault.age) {
            ageTextField.text = userAge
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension UIViewController {
    // Func: dismiss keyboard when tapping outside
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

