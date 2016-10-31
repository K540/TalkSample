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
    
    fileprivate var messages: [JSQMessage] = []
    fileprivate var incomingBubble: JSQMessagesBubbleImage!
    fileprivate var outgoingBubble: JSQMessagesBubbleImage!
    fileprivate var incomingAvatar: JSQMessagesAvatarImage!
    fileprivate var outgoingAvatar: JSQMessagesAvatarImage!
    // テスト用
    fileprivate let targetUser: JSON = ["senderId": "targetUser", "displayName": "passion"]

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
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        messages.append(message!)
        // 更新
        finishSendingMessage(animated: true)
        
        sendAutoMessage()
    }

    // メッセージの件数指定
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    // メッセージ行表示反映(メッセージ)
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    // メッセージ行表示反映(吹き出し)
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.item].senderId == senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    // メッセージ行表示反映(ユーザーアイコン)
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        if messages[indexPath.item].senderId == self.senderId {
            return outgoingAvatar
        }
        else {
            return incomingAvatar
        }
    }

    // メッセージ送信時刻表示反映(時刻)
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        if 0 == indexPath.item {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        else if 0 < indexPath.item - 1 {
            let previousMessage = messages[indexPath.item - 1]
            if message.date.timeIntervalSince(previousMessage.date) / 60 > 1 {
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            }
        }
        return nil
    }

    // メッセージ送信時刻表示反映(時刻高さ)
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if 0 == indexPath.item {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        else if 0 < indexPath.item - 1 {
            let previousMessage = messages[indexPath.item - 1]
            let message = messages[indexPath.item]
            if message.date .timeIntervalSince(previousMessage.date) / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }

    // その他セルのカスタマイズ用
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        // ユーザーアイコンに対してジェスチャーをつける
        var avatarGesture:UITapGestureRecognizer? = nil
        if messages[indexPath.item].senderId == self.senderId {
            avatarGesture = UITapGestureRecognizer(target: self, action: #selector(MessageTalkViewController.onTappedAvatar1))
        }
        else {
            avatarGesture = UITapGestureRecognizer(target: self, action: #selector(MessageTalkViewController.onTappedAvatar2))
        }

        if nil != avatarGesture {
            cell.avatarImageView?.isUserInteractionEnabled = true
            cell.avatarImageView?.addGestureRecognizer(avatarGesture!)
        }

        // 文字色を変える
        if messages[indexPath.item].senderId != senderId {
            cell.textView?.textColor = UIColor.darkGray
        } else {
            cell.textView?.textColor = UIColor.white
        }
        return cell
    }

    // TODO: [暫定]オートリプライ処理
    fileprivate func sendAutoMessage() {
        let message = JSQMessage(senderId: targetUser["senderId"].string, displayName: targetUser["displayName"].string, text: "今日はもう帰れ")
        if nil != message {
            messages.append(message!)
        }
        finishReceivingMessage(animated: true)
    }

    // メモリ不足によるアプリ終了通知
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 初期化処理
    fileprivate func initialSettings() {
        // 自分の情報入力
        self.senderId = "self"
        self.senderDisplayName = "自分の名前"
        // 吹き出しの色設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        
        // 自分の画像設定
        let resData:Data? = getResourceImage("icon_user1")
        if nil != resData {
            let resImage:UIImage? = UIImage(data: resData!)
            if nil != resImage {
                self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: resImage, diameter: 64)
            }
        }
        // 相手の画像設定
        let resData2:Data? = getResourceImage("icon_user2")
        if nil != resData {
            let resImage2:UIImage? = UIImage(data: resData2!)
            if nil != resImage2 {
                self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: resImage2, diameter: 64)
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

    override func didPressAccessoryButton(_ sender: UIButton!) {
        selectImage()
    }

    fileprivate func selectImage() {
        let alertController = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラを起動", style: .default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let libraryAction = UIAlertAction(title: "カメラロールから選択", style: .default) { (UIAlertAction) -> Void in
            self.selectFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func selectFromCamera() {
        // カメラ機能制限判定
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
        else {
            // カメラ許可をしていない時の処理
            let alert: UIAlertController = UIAlertController(title: "",
                                                             message: "端末の「設定＞プライバシー＞カメラ」で「TalkSample」をオンにしてください。",
                                                             preferredStyle: UIAlertControllerStyle.alert)
            let actionOK: UIAlertAction = UIAlertAction(title: "OK",
                                                        style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) -> Void in
                // OKボタン押下時の処理
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            })
            alert.addAction(actionOK)
            present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] {
            sendImageMessage(image as! UIImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    fileprivate func sendImageMessage(_ image: UIImage) {
        let photoItem = JSQPhotoMediaItem(image: image)
        let imageMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photoItem)
        messages.append(imageMessage!)
        finishSendingMessage(animated: true)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        if messages[indexPath.item].isMediaMessage {
            let media = messages[indexPath.item].media
            if (media? .isKind(of: JSQPhotoMediaItem.self))! {
                print("tapped Image")
            }
        }
    }

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
    
    // ナビゲーションバーを再表示する処理
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}
