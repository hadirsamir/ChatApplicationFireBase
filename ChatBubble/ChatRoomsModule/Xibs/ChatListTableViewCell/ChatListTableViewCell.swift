//
//  ChatListTableViewCell.swift
//  ChatBubble
//
//  Created by ASamir on 8/26/19.
//  Copyright © 2019 Samir. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    @IBOutlet weak var chatGroupName : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
