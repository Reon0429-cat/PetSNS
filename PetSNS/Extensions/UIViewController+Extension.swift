//
//  UIViewController+Extension.swift
//  PetSNS
//
//  Created by 大西玲音 on 2021/08/29.
//

import UIKit

extension UIViewController {
    
    static func instantiate() -> Self {
        var storyboardName = String(describing: self)
        if let result = storyboardName.range(of: "ViewController") {
            storyboardName.removeSubrange(result)
        } else {
            fatalError("Storyboardの名前が正しくない")
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! Self
        return vc
    }
    
}

extension UIViewController {
    
    func showErrorAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showTwoChoicesAlert(title: String,
                             cancelTitle: String,
                             destructiveTitle: String,
                             destructiveHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle,
                                      style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: destructiveTitle,
                                      style: .destructive,
                                      handler: destructiveHandler))
        present(alert, animated: true, completion: nil)
    }
    
}
