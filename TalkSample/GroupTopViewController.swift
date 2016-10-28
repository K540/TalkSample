//
//  GroupTopViewController.swift
//  TalkSample
//
//  Created by kobori on 2016/10/27.
//  Copyright © 2016年 KSF. All rights reserved.
//

import UIKit

class GroupTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // テキスト入力欄
    @IBOutlet weak var inputText: UITextField!

    // 画像のファイル名
    let imageNames = ["icon_user10.png", "icon_user11.png", "icon_user12.png", "icon_user13.png"]
    
    // 画像のタイトル
    let imageTitles = ["佐藤", "鈴木", "高橋", "田中"]

    // 投稿者の所属
    let imageSubTitles = ["開発部", "開発部", "営業部", "管理部"]
    
    // 投稿時間
    let postTime = ["2016/10/28 10:10", "2016/10/28 12:01", "2016/10/28 12:30", "2016/10/28 14:50"]
    
    // 本文
    let postSentence = ["飲み会しましょう！！！", "参加しまーす", "いいですねー＾＾", "私、近場でおすすめのお店あります♪"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! GroupCustomTableViewCell
        
        // セルに値を設定
        cell.setCell(imageNames[indexPath.row], titleText: imageTitles[indexPath.row], imageSubTitles: imageSubTitles[indexPath.row], postTime: postTime[indexPath.row], postSentence: postSentence[indexPath.row])
        
        return cell
    }
    
    // ナビゲーションバーを非表示にする処理
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
}
