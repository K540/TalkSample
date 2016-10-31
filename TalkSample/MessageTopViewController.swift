//
//  MessageTopViewController.swift
//  TalkSample
//
//  Created by kobori on 2016/10/25.
//  Copyright © 2016年 KSF. All rights reserved.
//

import UIKit

class MessageTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 画像のファイル名
    let imageNames = ["dog.jpg", "cat.jpg", "piyo.jpg", "seal.jpg", "squirrel.jpg"]
    
    // 画像のタイトル
    let imageTitles = ["いぬ", "ねこ", "ひよこ", "あざらし", "りす"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! CustomTableViewCell
        
        // セルに値を設定
        cell.setCell(imageNames[indexPath.row], titleText: imageTitles[indexPath.row])
        
        return cell
    }
    
    // ナビゲーションバーを非表示にする処理
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

}

