//
//  ImageMessageViewCell.swift
//  Chat
//
//  Created by Даир Алаев on 04.05.2021.
//

import UIKit
import Kingfisher

class ImageMessageViewCell: UITableViewCell {
    public static var id: String = "ImageMessageViewCell"

    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var imageMessageView: UIImageView!
    
    public var message: ImageMessageEntity? {
        didSet {
            if let message = message {
                senderLabel.text = message.sender
                let url = URL(string: message.imageURL)!
                let resource = ImageResource(downloadURL: url)
                imageMessageView.kf.setImage(with: resource)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
