//
//  AddToDoViewController.swift
//  ToDoApplication
//
//  Created by Dheeraj Arora on 08/11/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import  CoreData
class AddToDoViewController: UIViewController {
    
    //MARK: Property
    var manageContext: NSManagedObjectContext!
    var todo: ToDo?
    
    //MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomContraints:NSLayoutConstraint!
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        textView.becomeFirstResponder()
        
        if let todo = todo{
            textView.text = todo.title
            textView.text = todo.title
            segmentedControl.selectedSegmentIndex = Int(todo.prioty)
        }
    }
    

    //MARK: Handlers
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       
    }
   @objc func keyboardWillShow(with notification: Notification) {
    
    let key = "UIKeyboardFrameEndUserInfoKey"
    guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
    let keyboardHeight = keyboardFrame.cgRectValue.height
    bottomContraints.constant = keyboardHeight + 16
    UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
    }
}
    
    @IBAction func cancelAction(_ sender: UIButton) {
        goBackAction()
    }
    
    func goBackAction() {
        self.navigationController?.popViewController(animated: true)
        textView.resignFirstResponder()
    }
    @IBAction func doneAction(_ sender: UIButton) {
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        if let todo = self.todo{
            
            todo.title = title
            todo.prioty = Int16(segmentedControl.selectedSegmentIndex)
            
        }else{
            if let manage = manageContext{
                let todo = ToDo(context: manage)
                todo.title = title
                todo.prioty = Int16(segmentedControl.selectedSegmentIndex)
                todo.date = Date()
            }
           
        }
        do {
            if let manage = manageContext{
                try manage.save()
              
            }
              goBackAction()
        }
        catch  {
            print("Error in saving todo:\(error)")
        }
       

    }
}

extension AddToDoViewController: UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden{
            textView.text.removeAll()
            textView.textColor = .white
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
   
}
