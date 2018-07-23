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
    var saveTwitClosure: (_ newTwit:String)->() = {newTwit in }

    //MARK: UIViewController

    override func viewDidLoad()
    {
        super.viewDidLoad()
        twitView.layer.cornerRadius = 5
        twitView.layer.masksToBounds = true
    }

    override func viewDidAppear(_ animated: Bool)
    {
        twitTextView.becomeFirstResponder()
    }

    //MARK: Actions

    @IBAction func saveTwit(sender: UIBarButtonItem)
    {
        if twitTextView.text.count > 0
        {
            saveTwitClosure(twitTextView.text)
        }
    }

    @IBAction func cancel(sender: UIBarButtonItem)
    {
        self.twitTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    //MARK: UITextViewDelegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView)
    {
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
    }

    func textViewDidChange(_ textView: UITextView)
    {
    }

}
