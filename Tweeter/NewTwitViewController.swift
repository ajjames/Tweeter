//
//  NewTwitViewController.swift
//  Tweeter
//
//  Created by Andrew James on 2/14/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import UIKit

class NewTwitViewController: UIViewController, UITextViewDelegate
{
    @IBOutlet var twitView: UIView!
    @IBOutlet var twitTextView: UITextView!
    var saveTwitClosure: (newTwit:String)->() = {newTwit in }

    //MARK: UIViewController

    override func viewDidLoad()
    {
        super.viewDidLoad()
        twitView.layer.cornerRadius = 5
        twitView.layer.masksToBounds = true
    }

    override func viewDidAppear(animated: Bool)
    {
        twitTextView.becomeFirstResponder()
    }

    //MARK: Actions

    @IBAction func saveTwit(sender: UIBarButtonItem)
    {
        if countElements(twitTextView.text) > 0
        {
            saveTwitClosure(newTwit: twitTextView.text)
        }
    }

    @IBAction func cancel(sender: UIBarButtonItem)
    {
        self.twitTextView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: UITextViewDelegate

    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        return true
    }

    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return true
    }

    func textViewDidBeginEditing(textView: UITextView)
    {
    }

    func textViewDidEndEditing(textView: UITextView)
    {
    }

    func textViewDidChange(textView: UITextView)
    {
    }

}
