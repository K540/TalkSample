//
//  GroupCustomTableViewCell.swift
//  TalkSample
//
//  Created by kobori on 2016/10/28.
//  Copyright © 2016年 KSF. All rights reserved.
//

import UIKit

class GroupCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myTitleLabel: UILabel!
    
    @IBOutlet weak var mySubTitleLabel: UILabel!
    
    @IBOutlet weak var myPostTimeLabel: UILabel!
    
    @IBOutlet weak var myPostSentenceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// 投稿情報を設定するメソッド
    func setCell(imageName: String, titleText: String, imageSubTitles: String, postTime: String, postSentence: String) {
        myImageView.image = UIImage(named: imageName)
        myTitleLabel.text = titleText
        mySubTitleLabel.text = imageSubTitles
        myPostTimeLabel.text = postTime
        myPostSentenceLabel.text = postSentence
    }
    
}
