//
//  GroupTopViewController.swift
//  TalkSample
//
//  Created by kobori on 2016/10/27.
//  Copyright © 2016年 KSF. All rights reserved.
//

import UIKit

class GroupTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // テキスト入力欄
    @IBOutlet weak var myTextView: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    // 現在アクティブ(編集中)のTextField
    var activeField: UITextField!

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
        
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: "commitButtonTapped")
        
        
        kbToolBar.items = [spacer, commitButton]
        
        
        myTextView.inputAccessoryView = kbToolBar
        myTextView.delegate = self;
        
        registerForKeyboardNotifications()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! GroupCustomTableViewCell
        
        // セルに値を設定
        cell.setCell(imageName: imageNames[indexPath.row], titleText: imageTitles[indexPath.row], imageSubTitles: imageSubTitles[indexPath.row], postTime: postTime[indexPath.row], postSentence: postSentence[indexPath.row])
        
        return cell
    }
    
    // ナビゲーションバーを非表示にする処理
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // ボタンが押された時に呼ばれるアクション
    func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver (
            self,
            selector: #selector(GroupTopViewController.keyboardWasShown(_:)),
            name: NSNotification.Name("UIKeyboardDidShowNotification"),
            object: nil
        )
        
        NotificationCenter.default.addObserver (
            self,
            selector: #selector(GroupTopViewController.keyboardWillBeHidden(_:)),
            name: NSNotification.Name("UIKeyboardWillHideNotification"),
            object: nil
        )
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWasShown(_ aNotification: NSNotification) {
        print("keyboardWasShown\n")
        let info: NSDictionary = aNotification.userInfo! as NSDictionary
        let kbRect:CGRect? = info.object(forKey: UIKeyboardFrameBeginUserInfoKey) as? CGRect
        if nil != kbRect {
            let kbSize: CGSize = kbRect!.size;
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= (kbSize.height + 40)
            if nil != activeField {
                var rect:CGRect = (activeField.superview?.frame)!
                rect.origin.x += activeField.frame.origin.x
                rect.origin.y += activeField.frame.origin.y
                if (!aRect.contains(rect) ) {
                    self.scrollView.scrollRectToVisible(rect, animated: true)
                }
            }
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(_ aNotification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing\n")
        activeField = textField;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil;
    }
}
