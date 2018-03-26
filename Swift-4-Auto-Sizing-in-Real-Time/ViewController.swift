//
//  ViewController.swift
//  Swift-4-Auto-Sizing-in-Real-Time
//
//  Created by Ünal Öztürk on 26.03.2018.
//  Copyright © 2018 Ünal Öztürk. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIGestureRecognizerDelegate {
    
    var textView: UITextView!
    var bottomAnchor : NSLayoutConstraint?

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
       

        setupTextView()
        setupKeyboard()
        setupTapGesture()
        
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    @objc func handleKeyboardWillShow(notification : NSNotification) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double)
        print(keyboardSize.height)
        
        /*textView.constraints.filter {
            ($0.firstItem === view || $0.secondItem === view) &&
                ($0.firstAttribute == .bottom || $0.secondAttribute == .bottom)
            }.first?.constant = -keyboardSize.height*/
        
       // textView.constraints.filter { $0.firstAttribute == .bottom }.map { $0.constant = -keyboardSize.height };
        bottomAnchor?.constant = -keyboardSize.height
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
           
        }
        
    }
    @objc func handleKeyboardWillHide(notification : NSNotification) {
        let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double)
        bottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    func setupTextView()    {
        //create text view
        textView  =  {
            let tf = UITextView()
            tf.backgroundColor = .red
            tf.isScrollEnabled = false
            tf.text = "There is some text,There is some text,There is some text,There is some text,There is some text,"
            tf.font = UIFont.preferredFont(forTextStyle: .headline)
            return tf
        }()
        
        view.addSubview(textView)
        
        //use auto layout to set my textview frame..kinda
        textView.translatesAutoresizingMaskIntoConstraints = false
        [
            //textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 50)
        ].forEach{ $0.isActive = true }
        
        bottomAnchor = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomAnchor?.isActive = true
        
        textView.delegate = self
        textViewDidChange(textView)
    }
}
extension ViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize =  textView.sizeThatFits(size)
        
        textView.constraints.filter { $0.firstAttribute == .height }.map { $0.constant = estimatedSize.height }
    }
}

