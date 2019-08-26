//
//  ViewController.swift
//  ChatBubble
//
//  Created by ASamir on 8/12/19.
//  Copyright © 2019 Samir. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

    }


}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "formcell", for: indexPath) as! FormCollectionViewCell
        if indexPath.row == 0 {
            cell.userNameView.isHidden = true
            cell.signUpBtn.setTitle("logIn", for: .normal)
            cell.signInBtn.setTitle("SignIn 👉🏻", for: .normal)
            cell.signInBtn.addTarget(self, action:#selector(slideToSignIn) , for: .touchUpInside)
            cell.signUpBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        }else{
           cell.userNameView.isHidden = false
          cell.signUpBtn.setTitle("signUp", for: .normal)
          cell.signInBtn.setTitle("signIn 👈", for: .normal)
            cell.signUpBtn.addTarget(self, action: #selector(SignUpAction), for: .touchUpInside)
             cell.signInBtn.addTarget(self, action:#selector(slideToSignUp) , for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.frame.size
    }
    @objc func slideToSignIn(){
        let indexPath = IndexPath(item: 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    @objc func slideToSignUp(){
        let indexPath = IndexPath(item: 0, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    //registeration
    @objc func SignUpAction(){
          let indexPath = IndexPath(item: 1, section: 0)
          let cell = self.collectionView.cellForItem(at: indexPath) as! FormCollectionViewCell
        guard let emailAddresse = cell.emailTextField.text,let password = cell.passTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: emailAddresse, password: password) { (result, error) in
            guard let userId = result?.user.uid, let userName = cell.userNameTextField.text else {
                return
            }
            self.dismiss(animated: true, completion: nil)
            if (error == nil) {
                let refrence = Database.database().reference()
                let user = refrence.child("users").child(userId)
                let dataArray :[String : Any] = ["userName": userName]
                user.setValue(dataArray)
            }
        }
    }
    //LogIn
    @objc func loginAction(){
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! FormCollectionViewCell
        guard let emailAddresse = cell.emailTextField.text,let password = cell.passTextField.text else {
            return
        }
        if emailAddresse.isEmpty || password.isEmpty {
            self.displayError(errorMessage: "Empty Fields")
        }else
        {
        Auth.auth().signIn(withEmail: emailAddresse, password: password) { (result, error) in
            if (error == nil){
                self.dismiss(animated: true, completion: nil)
            }else{
                self.displayError(errorMessage: "Wrong userName or password")
            }
        }
        }
    }
    func displayError(errorMessage : String){
        let alert = UIAlertController.init(title: "Error", message: errorMessage, preferredStyle: .alert)
        let dismissBtn =  UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissBtn)
        self.present(alert, animated: true, completion: nil)
    }
}
