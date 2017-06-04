//
//  ReceiveViewController.swift
//  FirebaseSwimee
//
//  Created by ShinokiRyosei on 2016/10/26.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase


// MARK: - ReceiveViewController

class ReceiveViewController: UIViewController {

    @IBOutlet private weak var searchIDTextField: UITextField!
    @IBOutlet private weak var postTextView: UITextView!
    
    private let ref = FIRDatabase.database().reference().child("idList")
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configureNavBar()
    }
    
    
    // MARK: Private
    
    private func configureNavBar() {
        self.title = "受信"
    }
    
    private func configureTextField() {
        searchIDTextField.delegate = self
        searchIDTextField.keyboardType = .asciiCapable
    }
    
    @IBAction private func selectReceive() {
        guard let searchID = searchIDTextField.text else { return }
        if searchID == "" { return }
        
        ref.child(searchID).observeSingleEvent(of: .value, with: { snapshot in
            guard let postValue = snapshot.value as? [String: Any] else {
                self.postTextView.text = "idに該当する投稿が存在しませんでした。"
                return
            }
            
            var postText: String = ""
            
            let text = postValue["text"] as? String
            
            let timeStamps = postValue["timestamps"]! as? TimeInterval
            let date = Date(timeIntervalSince1970: timeStamps!/1000)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            
            postText += "id: " + searchID + "\n"
            postText += "text: " + text! + "\n"
            postText += "date: " + formatter.string(from: date) + "\n"
            
            self.postTextView.text = postText
        })
    }
}

extension ReceiveViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - StoryboardInstantiable

extension ReceiveViewController: StoryboardInstantiable {
    
    static var storyboardName: String {
        
        return String(describing: self)
    }
}
