//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by KOPPOLA GOKUL SAI on 24/12/23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var leftImageAvatar: UIImageView!
    @IBOutlet weak var messageBubble: UIView!

    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageBubble.layer.cornerRadius = messageBubble.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
