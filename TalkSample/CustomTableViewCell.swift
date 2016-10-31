//
//  CustomTableViewCell.swift
//  TalkSample
//
//  Created by kobori on 2016/10/25.
//  Copyright © 2016年 KSF. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// 画像・タイトル・説明文を設定するメソッド
    func setCell(_ imageName: String, titleText: String) {
        myImageView.image = UIImage(named: imageName)
        myTitleLabel.text = titleText
     }

}
