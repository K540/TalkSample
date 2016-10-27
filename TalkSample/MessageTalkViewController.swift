//
//  MessageTalkViewController.swift
//  TalkSample
//
//  Created by koshimaru on 2016/10/25.
//  Copyright © 2016年 KSF. All rights reserved.
//

import UIKit
import SwiftyJSON
import JSQMessagesViewController

class MessageTalkViewController: JSQMessagesViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private var messages: [JSQMessage] = []
    private var incomingBubble: JSQMessagesBubbleImage!
    private var outgoingBubble: JSQMessagesBubbleImage!
    private var incomingAvatar: JSQMessagesAvatarImage!
    private var outgoingAvatar: JSQMessagesAvatarImage!
    // テスト用
    private let targetUser: JSON = ["senderId": "targetUser", "displayName": "passion"]

    //-----------------------------------------------
    // Override Methods.
    //-----------------------------------------------
    // [UIViewController]
    // 画面ロード完了
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }

    // [JSQMessagesViewController]
    // Message送信ボタン押下
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        messages.append(message)
        // 更新
        finishSendingMessageAnimated(true)
        
        sendAutoMessage()
    }

    // メッセージの件数指定
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    // メッセージ行表示反映(メッセージ)
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    // メッセージ行表示反映(吹き出し)
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.item].senderId == senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    // メッセージ行表示反映(ユーザーアイコン)
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        if messages[indexPath.item].senderId == self.senderId {
            return outgoingAvatar
        }
        else {
            return incomingAvatar
        }
    }

    // メッセージ送信時刻表示反映(時刻)
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        if 0 == indexPath.item {
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        else if 0 < indexPath.item - 1 {
            let previousMessage = messages[indexPath.item - 1]
            if message.date.timeIntervalSinceDate(previousMessage.date) / 60 > 1 {
                return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
            }
        }
        return nil
    }

    // メッセージ送信時刻表示反映(時刻高さ)
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if 0 == indexPath.item {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        else if 0 < indexPath.item - 1 {
            let previousMessage = messages[indexPath.item - 1]
            let message = messages[indexPath.item]
            if message.date .timeIntervalSinceDate(previousMessage.date) / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }

    // その他セルのカスタマイズ用
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        // ユーザーアイコンに対してジェスチャーをつける
        var avatarGesture:UITapGestureRecognizer? = nil
        if messages[indexPath.item].senderId == self.senderId {
            avatarGesture = UITapGestureRecognizer(target: self, action: "onTappedAvatar1")
        }
        else {
            avatarGesture = UITapGestureRecognizer(target: self, action: "onTappedAvatar2")
        }

        if nil != avatarGesture {
            cell.avatarImageView?.userInteractionEnabled = true
            cell.avatarImageView?.addGestureRecognizer(avatarGesture!)
        }

        // 文字色を変える
        if messages[indexPath.item].senderId != senderId {
            cell.textView?.textColor = UIColor.darkGrayColor()
        } else {
            cell.textView?.textColor = UIColor.whiteColor()
        }
        return cell
    }

    // TODO: [暫定]オートリプライ処理
    private func sendAutoMessage() {
        let message = JSQMessage(senderId: targetUser["senderId"].string, displayName: targetUser["displayName"].string, text: "今日はもう帰れ")
        messages.append(message)
        finishReceivingMessageAnimated(true)
    }

    // メモリ不足によるアプリ終了通知
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 初期化処理
    private func initialSettings() {
        // 自分の情報入力
        self.senderId = "self"
        self.senderDisplayName = "自分の名前"
        // 吹き出しの色設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        self.outgoingBubble = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        
        // 自分の画像設定
        let resData:NSData? = getResourceImage("icon_user1")
        if nil != resData {
            let resImage:UIImage? = UIImage(data: resData!)
            if nil != resImage {
                self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(resImage, diameter: 64)
            }
        }
        // 相手の画像設定
        let resData2:NSData? = getResourceImage("icon_user2")
        if nil != resData {
            let resImage2:UIImage? = UIImage(data: resData2!)
            if nil != resImage2 {
                self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(resImage2, diameter: 64)
            }
        }
        // 自分の画像を表示しない
        //        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }

    // ユーザー1アイコン押下
    func onTappedAvatar1() {
        print("tapped user avatar 1")
    }

    // ユーザー2アイコン押下
    func onTappedAvatar2() {
        print("tapped user avatar 2")
    }

    override func didPressAccessoryButton(sender: UIButton!) {
        selectImage()
    }

    private func selectImage() {
        let alertController = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "カメラを起動", style: .Default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let libraryAction = UIAlertAction(title: "カメラロールから選択", style: .Default) { (UIAlertAction) -> Void in
            self.selectFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) { (UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func selectFromCamera() {
        // カメラ機能制限判定
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        else {
            // カメラ許可をしていない時の処理
            let alert: UIAlertController = UIAlertController(title: "",
                                                             message: "端末の「設定＞プライバシー＞カメラ」で「TalkSample」をオンにしてください。",
                                                             preferredStyle: UIAlertControllerStyle.Alert)
            let actionOK: UIAlertAction = UIAlertAction(title: "OK",
                                                        style: UIAlertActionStyle.Default, handler:{ (action: UIAlertAction!) -> Void in
                // OKボタン押下時の処理
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            alert.addAction(actionOK)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] {
            sendImageMessage(image as! UIImage)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    private func sendImageMessage(image: UIImage) {
        let photoItem = JSQPhotoMediaItem(image: image)
        let imageMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photoItem)
        messages.append(imageMessage)
        finishSendingMessageAnimated(true)
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        if messages[indexPath.item].isMediaMessage {
            let media = messages[indexPath.item].media
            if media .isKindOfClass(JSQPhotoMediaItem) {
                print("tapped Image")
            }
        }
    }

    /// リソース内からpng画像を取り出し、NSData形式で返却する
    /// - parameter name : 画像の名前(パス)。拡張子[png]は省略。
    /// - returns : NSData形式のpng画像 存在しなければnilを返す。
    func getResourceImage(name:String)-> NSData?{
        let bundlePath : String = NSBundle.mainBundle().pathForResource("Resources", ofType: "bundle")!
        let bundle : NSBundle = NSBundle(path: bundlePath)!
        if let imagePath : String = bundle.pathForResource(name, ofType: "png"){
            let fileHandle : NSFileHandle = NSFileHandle(forReadingAtPath: imagePath)!
            let imageData : NSData = fileHandle.readDataToEndOfFile()
            return imageData
        }
        return nil
    }
    
    // ナビゲーションバーを再表示する処理
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

}