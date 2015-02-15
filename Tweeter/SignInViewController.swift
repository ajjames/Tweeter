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

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillChangeFrame:", name:UIKeyboardWillChangeFrameNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    //MARK: Keyboard Notifications

    func keyboardWillChangeFrame(notification:NSNotification)
    {
        var height = CGFloat(0)
        if let some = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().origin.y
        {
            height = some
        }

        if let some = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().origin.y
        {
            let delta = min(-(height - some), 0)
            height = delta / 2.0
        }

        self.signInViewCenterYConstraint.constant = height
        self.view.layoutIfNeeded()
    }

    //MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        spinner.startAnimating()
        User.signIn(usernameTextField.text, password: passwordTextField.text) { username, error in
            GCDDispatchMain({
                if let someUsername = username
                {
                    self.spinner.stopAnimating()
                    textField.endEditing(true)
                    self.dismissViewControllerAnimated(true, completion: nil)
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
        UIView.animateWithDuration(0.02, animations: { () -> Void in
            self.signInView.transform = CGAffineTransformMakeTranslation(-8, 0)
            }, completion: { finished in

                UIView.animateWithDuration(0.04, animations: { () -> Void in
                    self.signInView.transform = CGAffineTransformMakeTranslation(16, 0)
                    }, completion: { finished in

                        UIView.animateWithDuration(0.02, animations: { () -> Void in
                            self.signInView.transform = CGAffineTransformIdentity
                            }, completion:nil)
                })
        })
    }

}
