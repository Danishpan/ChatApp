//
//  MessageCell.swift
//  Chat
//
//  Created by Даир Алаев on 03.05.2021.
//

import UIKit
import Kingfisher

class MessageCell: UITableViewCell {
    public static var id: String = "MessageCell"
    
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var imageMessageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerHeightConstraint: NSLayoutConstraint!
    
    
    public var message: MessageEntity? {
        didSet {
            if let message = message {
                senderLabel.text = message.sender
                messageLabel.text = message.message
//                if message.imageURL != "" {
//                    let url = URL(string: message.imageURL)!
//                    let resource = ImageResource(downloadURL: url)
//                    imageMessageView.kf.setImage(with: resource)
//                }
//                } else {
//                    containerHeightConstraint.constant = containerHeightConstraint.constant - 100
//                }

//                    let url = URL(string: "https://cdnimg.rg.ru/img/content/161/31/13/kinopoisk.ru-Shrek-13985_d_850.jpg")
//                  imageMessageView.kf.setImage(with: url)
//                  let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//                        guard let data = data, error == nil else {
//                            return
//                        }
//
//                        DispatchQueue.main.async {
//                            let image = UIImage(data: data)
//                            self.imageMessageView.image = image
//                        }
//                    }
//                    task.response
//                    imageMessageView.isHidden = true
//                    containerView.backgroundColor = .white
//                    containerView.frame.size.height = 65
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
