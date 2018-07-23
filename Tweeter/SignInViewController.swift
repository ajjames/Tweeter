//
//  SignInViewController.swift
//  Tweeter
//
//  Created by Andrew James on 2/13/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInView: UIView!
    @IBOutlet var signInViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var spinner: UIActivityIndicatorView!
    var signedInClosure: ()->() = {}

    //MARK: UIViewController

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self);
    }

    //MARK: Keyboard Notifications

    @objc func keyboardWillChangeFrame(notification:NSNotification)
    {
        var height = CGFloat(0)
        if let some = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.origin.y
        {
            height = some
        }

        if let some = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.origin.y
        {
            let delta = min(-(height - some), 0)
            height = delta / 2.0
        }

        self.signInViewCenterYConstraint.constant = height
        self.view.layoutIfNeeded()
    }

    //MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        spinner.startAnimating()
        User.signIn(username: usernameTextField.text!, password: passwordTextField.text ?? "") { username, error in
            GCDDispatchMain(closure: {
                if username != nil
                {
                    self.spinner.stopAnimating()
                    textField.endEditing(true)
                    self.dismiss(animated: true, completion: nil)
                    self.signedInClosure()
                }
                else
                {
                    self.spinner.stopAnimating()
                    self.showFailSignIn()
                }
            })
        }
        return true
    }

    //MARK: private

    private func showFailSignIn()
    {
        UIView.animate(withDuration: 0.02, animations: { () -> Void in
            self.signInView.transform = CGAffineTransform(translationX: -8, y: 0)
            }, completion: { finished in

                UIView.animate(withDuration: 0.04, animations: { () -> Void in
                    self.signInView.transform = CGAffineTransform(translationX: 16, y: 0)
                    }, completion: { finished in

                        UIView.animate(withDuration: 0.02, animations: { () -> Void in
                            self.signInView.transform = .identity
                            }, completion:nil)
                })
        })
    }

}
