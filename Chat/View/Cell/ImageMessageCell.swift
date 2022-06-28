//
//  ImageMessageCell.swift
//  Chat
//
//  Created by Даир Алаев on 05.05.2021.
//

import UIKit
import Kingfisher

class ImageMessageCell: UITableViewCell {
    public static var id: String = "ImageMessageCell"

    @IBOutlet private weak var senderTitle: UILabel!
    @IBOutlet private weak var imageMessageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    public var message: ImageMessageEntity? {
        didSet {
            if let message = message {
                senderTitle.text = message.sender
                if message.imageURL != "" {
                    let url = URL(string: message.imageURL)!
                    let resource = ImageResource(downloadURL: url)
                    imageMessageView.kf.indicatorType = .activity
                    imageMessageView.kf.setImage(with: resource)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 4
        containerView.layer.masksToBounds = true
    }

    
}
