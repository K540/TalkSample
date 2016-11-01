//
//  CustomTableViewCell2.swift
//  TalkSample
//
//  Created by koshimaru on 2016/10/28.
//  Copyright © 2016年 KSF. All rights reserved.
//

import UIKit

class CustomTableViewCell2: UITableViewCell {
    // ステータス
    @IBOutlet weak var txtStatus: UILabel!
    // 名前
    @IBOutlet weak var txtName: UILabel!
    // 所属
    @IBOutlet weak var txtTeam: UILabel!
    // タイトル
    @IBOutlet weak var txtTitle: UILabel!
    // 日時
    @IBOutlet weak var txtDate: UILabel!
    // アイコン
    @IBOutlet weak var imgIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// セル内オブジェクト設定
    func setCell(_ status: String,
                 name: String,
                 team: String,
                 title: String,
                 date: String,
                 icon: UIImage?) {
        txtStatus.text = status
        txtName.text = name
        txtTeam.text = team
        txtTitle.text = title
        txtDate.text = date
        if nil != icon {
            imgIcon.image = icon!
        }
    }
}
