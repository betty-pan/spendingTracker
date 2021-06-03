//
//  File.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/8.
//

import Foundation
import UIKit

extension UITextField {
    func setNumberKeyboardReturn(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space,doneBtn], animated: true)

        self.inputAccessoryView = toolBar
    }
    @objc func selectDoneButton(){
        self.resignFirstResponder()
    }
}
extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
