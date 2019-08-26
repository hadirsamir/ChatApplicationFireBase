//
//  BubbleTableViewCell.swift
//  ChatBubble
//
//  Created by ASamir on 8/12/19.
//  Copyright © 2019 Samir. All rights reserved.
//

import UIKit

class BubbleTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var messageTextView : UITextView!
    @IBOutlet weak var mesaageStackView : UIStackView!
    @IBOutlet weak var messageMainView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        messageMainView.layer.cornerRadius = 6
    }
    func setMessageData(messageObject : MessageModel){
        self.messageTextView.text = messageObject.messageText
        self.userNameLabel.text   = messageObject.senderName
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    func setBubbleType (type : messageState){
        if type == .inComing{
            mesaageStackView.alignment = .leading
            messageMainView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            messageTextView.textColor = .white
        
        }// send by me case
        else if type == .outGoing{
            mesaageStackView.alignment = .trailing
            messageMainView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            messageTextView.textColor = .white
            
        }
        
    }
}
