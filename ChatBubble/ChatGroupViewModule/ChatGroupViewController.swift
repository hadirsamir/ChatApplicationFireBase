//
//  ChatGroupViewController.swift
//  ChatBubble
//
//  Created by ASamir on 8/26/19.
//  Copyright © 2019 Samir. All rights reserved.
//

import UIKit
import Firebase

class ChatGroupViewController: UIViewController {
    @IBOutlet weak var chattingTable : UITableView!
    @IBOutlet weak var sentMessage   : UITextField!
    @IBOutlet weak var sendButton    : UIButton!
    var sentRoomObject : RoomModel?
    var messageObjectArray  = [MessageModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sentRoomObject?.roomName
        self.chattingTable.delegate   = self
        self.chattingTable.dataSource = self
        self.registerNibs()
        self.observeMessage()
        self.chattingTable.allowsSelection = false
        // Do any additional setup after loading the view.
    }
    func observeMessage(){
        guard let roomId = self.sentRoomObject?.roomId else{
            return
        }
        let ref = Database.database().reference()
        ref.child("rooms").child(roomId).child("messages").observe(.childAdded) { (DataSnapshot) in
            if let dataArray = DataSnapshot.value as? [String : Any]{
                guard let userName  = dataArray["username"] as? String,let messageTextContent = dataArray["text"] as? String ,let userId = dataArray ["userId"] as? String else {
                    return
                }
                let message = MessageModel.init(messageKey: DataSnapshot.key, senderName: userName, messageText: messageTextContent, senderId: userId)
                self.messageObjectArray.append(message)
                print(self.messageObjectArray.count)
                self.chattingTable.reloadData()
            }
            
        }
    }
    func sendMessage (text : String){
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let refrence = Database.database().reference()
        let user = refrence.child("users").child(userId)
        user.child("userName").observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let userName = DataSnapshot.value as? String {
                if let roomId = self.sentRoomObject?.roomId,let userId = Auth.auth().currentUser?.uid{
                    let dataArray : [String : Any] = ["username": userName,"text": text,"userId": userId]
                    let room = refrence.child("rooms").child(roomId)
                    room.child("messages").childByAutoId().setValue(dataArray, withCompletionBlock: { (error, DatabaseReference) in
                        if error == nil {
                            
                        }
                    })
                    
                }
            }
        })
    }
    @IBAction func sendMessageAction(){
        guard let chatText = self.sentMessage.text else {
            return
        }
      sendMessage(text: chatText)
        self.chattingTable.reloadData()
    }
   
    func registerNibs(){
            chattingTable.register(UINib(nibName: "BubbleTableViewCell", bundle: nil), forCellReuseIdentifier: "BubbleTableViewCell")
    }

}
extension ChatGroupViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageObjectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "BubbleTableViewCell", for: indexPath) as! BubbleTableViewCell
        cell.setMessageData(messageObject: self.messageObjectArray[indexPath.row])
        if self.messageObjectArray[indexPath.row].senderId == Auth.auth().currentUser?.uid{
            cell.setBubbleType(type: .outGoing)
        }else{
            cell.setBubbleType(type: .inComing)
        }
       // cell.setBubbleType(type: .outGoing)
        return cell
    }
    
    
}
