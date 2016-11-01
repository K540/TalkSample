//
//  TaskTopViewController.swift
//  TalkSample
//
//  Created by koshimaru on 2016/10/27.
//  Copyright © 2016年 KSF. All rights reserved.
//

import UIKit

class TaskTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //--------------------------------------
    // TODO 暫定セルデータ
    //--------------------------------------
    // Status
    let txtStatusArray = ["明日以降",
                          "明日以降",
                          "明日以降",
                          "明日以降",
                          "今日",
                          "期限切れ"]
    // Name
    let txtNameArray = ["田中 佐羽雄",
                        "利田　粗太",
                        "江良　火流斗",
                        "倉井　安人",
                        "出財瀬　圭子",
                        "出財瀬　圭子"]
    // Team
    let txtTeamArray = ["サーバーアプリチーム",
                        "ソフト全体",
                        "ビルド担当",
                        "クライアントアプリチーム",
                        "デザインチーム",
                        "デザインチーム"]
    // Title
    let txtTitleArray = ["サーバーAPIリリース",
                         "サンプル用ソフトリリース",
                         "サンプル用ソフトビルド",
                         "デザイン適用",
                         "デザイン提出",
                         "デザインレビュー"]
    // Date
    let txtDateArray = ["2016/11/10 15:00:00",
                        "2016/11/03 12:00:00",
                        "2016/11/01 17:30:00",
                        "2016/10/31 19:00:00",
                        "2016/10/28 18:30:00",
                        "2016/10/28 12:15:00"]
    // 画像のファイル名
    let imgIconArray = ["icon_user1",
                        "icon_user1",
                        "icon_user1",
                        "icon_user1",
                        "icon_user2",
                        "icon_user2"]

    //-----------------------------------------------
    // Override Methods.
    //-----------------------------------------------
    // [UIViewController]
    // 画面ロード完了
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // [UIViewController]
    // 画面表示前処理
    override func viewWillAppear(_ animated: Bool) {
        // ナビゲーションバーを非表示
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // [UIViewController]
    // メモリ不足によるアプリ終了通知
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //-----------------------------------------------
    // Class Methods.
    //-----------------------------------------------
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgIconArray.count
    }

    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell2
        
        // セルに値を設定
        let resData:Data? = getResourceImage(imgIconArray[indexPath.row])
        var resImage:UIImage?
        if nil != resData {
            resImage = UIImage(data: resData!)
        }

        cell.setCell(txtStatusArray[indexPath.row],
                     name: txtNameArray[indexPath.row],
                     team: txtTeamArray[indexPath.row],
                     title: txtTitleArray[indexPath.row],
                     date: txtDateArray[indexPath.row],
                     icon: resImage)

        return cell
    }

    // ステータス文言を取得
    func getStatus(_ index:Int) -> String {
        var ret:String = ""

        // 指定セルの期日を取得
        
        // 期日文言を数値へそれぞれ変換
        
        // 現在日時と比較
        ret = "期限切れ"
        ret = "今日"
        ret = "明日"
        ret = "明日以降"
        ret = "期限なし"
        return ret
    }

    // TODO Utility候補
    /// 日時文字列をNSDate型へ変換
    ///  - parameter timeStr: 日時文字列(yyyy/MM/DD HH:MM:SS)
    ///  - returns: 引数に指定した日時のNSDate
    func getNSDateFromString(_ timeStr:String?) -> Date? {
        var retDate:Date?

        // 所定フォーマットの日時文字列からNSDataを作成
        if nil != timeStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/DD HH:MM:SS"
            retDate = formatter.date(from: timeStr!)
        }

        return retDate
    }

    // TODO Utility候補
    /// NSDate型から日時文字列へ変換
    ///  - parameter date: 日時を格納したNSDateオブジェクト
    ///  - parameter format: 指定フォーマット
    ///  - returns: 引数に指定した日時の文字列
    func getStringFromNSDate(_ date:Date?, format:String) -> String {
        var retStr:String = ""

        // 引数に指定されたフォーマットの日時文言を作成
        if nil != date {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            retStr = formatter.string(from: date!)
        }

        return retStr
    }

    // TODO Utility候補
    /// リソース内からpng画像を取り出し、NSData形式で返却する
    /// - parameter name : 画像の名前(パス)。拡張子[png]は省略。
    /// - returns : NSData形式のpng画像 存在しなければnilを返す。
    func getResourceImage(_ name:String)-> Data?{
        let bundlePath : String = Bundle.main.path(forResource: "Resources", ofType: "bundle")!
        let bundle : Bundle = Bundle(path: bundlePath)!
        if let imagePath : String = bundle.path(forResource: name, ofType: "png"){
            let fileHandle : FileHandle = FileHandle(forReadingAtPath: imagePath)!
            let imageData : Data = fileHandle.readDataToEndOfFile()
            return imageData
        }
        return nil
    }
}

