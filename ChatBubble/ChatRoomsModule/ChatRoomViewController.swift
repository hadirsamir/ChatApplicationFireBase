//
//  ChatRoomViewController.swift
//  ChatBubble
//
//  Created by ASamir on 8/19/19.
//  Copyright © 2019 Samir. All rights reserved.
//

import UIKit
import  Firebase
class ChatRoomViewController: UIViewController {
    @IBOutlet weak var chatListTableView : UITableView!
    @IBOutlet weak var newRoomTextField : UITextField!
    @IBOutlet weak var createChatRoomBtn : UIButton!
    //MARK:-
    var roomObjectArray = [RoomModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatListTableView.delegate = self
        self.chatListTableView.dataSource = self
        self.registeNibs()
        self.observeUpdate()
      
    }
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil) {
            self.presentLoginScreen()
        }
    }
    func registeNibs(){
        chatListTableView.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
    }
    @IBAction func didPressLogOut(_ sender: Any) {
        try! Auth.auth().signOut()
       self.presentLoginScreen()
    }
    func presentLoginScreen(){
        let formScreen = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(formScreen, animated: true, completion: nil)
    }
    @IBAction func createChateRoomAction(){
        guard let chatName = self.newRoomTextField.text else {
            return
        }
         let refrence = Database.database().reference()
         let room = refrence.child("rooms").childByAutoId()
        let data :[String : String] = ["roomName" : chatName]
        room.setValue(data) { (error, ref) in
            if (error == nil){
                self.newRoomTextField.text = ""
            }
        }
    }
    //observer function to update rooms table data in db in our tableview
    func observeUpdate (){
         let refrence = Database.database().reference()
        refrence.child("rooms").observe(.childAdded) { (dataAdded) in
            if let dataArray = dataAdded.value as? [String : Any]{
                if let roomName =  dataArray["roomName"] as? String {
                    // to get room id and name
                    let room = RoomModel.init(roomName: roomName, roomId: dataAdded.key)
                    self.roomObjectArray.append(room)
                    self.chatListTableView.reloadData()
                }
            }
        }
    }
}
extension ChatRoomViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomObjectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as!ChatListTableViewCell
        cell.chatGroupName.text = self.roomObjectArray[indexPath.row].roomName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoomView = self.storyboard?.instantiateViewController(withIdentifier: "ChatGroupViewController") as! ChatGroupViewController
        chatRoomView.sentRoomObject  = self.roomObjectArray[indexPath.row]
        self.navigationController?.pushViewController(chatRoomView, animated: true)
    }
}
