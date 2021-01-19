//
//  ViewController.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/4.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit
import HealthKit

protocol PassDataDelegate {
    func getName(name: String)
    func getAge(age: Int)
}


class MainViewController: UIViewController {
    
    let healthStore = HealthStore()
    
    var name = String()
    var age = Int()
    var passDataDelegate: PassDataDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    
    @IBAction func userNameBegin(_ sender: UITextField) {
        print("User name begin")
    }
    
    
    @IBAction func userNameEnd(_ sender: UITextField) {
        self.name = String(nameTextField.text ?? "404")
        nameTextField.endEditing(true)
        print("User name: \(self.name)")
        
        let tabbar = tabBarController as! TabBarController
        tabbar.ptpName = self.name
        
        //self.passDataDelegate!.getName(name: self.name)
    }
    
    @IBAction func ageBegin(_ sender: UITextField) {
        ageTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    
    @IBAction func ageEnd(_ sender: UITextField) {
        self.age = Int(ageTextField.text!) ?? 0
        ageTextField.endEditing(true)
        print("User age: \(self.age)")
        passDataDelegate!.getAge(age: self.age)
    }
    
//    @IBAction func userNameEntered(_ sender: UITextField) {
//        self.name = nameTextField.text!
//        nameTextField.endEditing(true)
//        print("User name: \(self.name)")
//        passDataDelegate.getName(name: self.name)
//    }
//
//    @IBAction func userAgeEntered(_ sender: UITextField) {
//
//        self.age = Int(ageTextField.text!) ?? 0
//        ageTextField.endEditing(true)
//        print("User age: \(self.age)")
//        passDataDelegate.getAge(age: self.age)
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2243741453, green: 0.2615192533, blue: 0.4102925658, alpha: 1)
        self.hideKeyboardWhenTappedAround()
        
        let tabbar = tabBarController as! TabBarController
        nameTextField.text = tabbar.ptpName
        
        healthStore.authorizeHealthKit()
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

