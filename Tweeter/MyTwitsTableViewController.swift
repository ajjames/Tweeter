//
//  MyTwitsTableViewController.swift
//  Tweeter
//
//  Created by Andrew James on 2/13/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import UIKit

class MyTwitsTableViewController: UITableViewController
{
    var twitDataSource: TwitDataSource!

    //MARK: UIViewController

    override func viewDidLoad()
    {
        super.viewDidLoad()
        twitDataSource = TwitDataSource()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0

        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = UIColor.whiteColor()
        refreshControl!.addTarget(self, action:"fetchTwits", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        if User.currentUser == nil
        {
            performSegueWithIdentifier("showSignIn", sender: nil)
        }
        else
        {
            fetchTwits()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showNewTwit"
        {
            if let destinationViewController = segue.destinationViewController as? NewTwitViewController
            {
                destinationViewController.saveTwitClosure = self.saveTwit
            }
        }
        else if segue.identifier == "showSignIn"
        {
            User.signout()
            tableView.reloadData()
            if let destinationViewController = segue.destinationViewController as? SignInViewController
            {
                destinationViewController.signedInClosure = self.didSignIn
            }
        }
    }

    //MARK: UITableViewController

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return twitDataSource.twits.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:TwitTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("twitCell") as TwitTableViewCell
        let rowIndex = max(twitDataSource.twits.count - indexPath.row - 1,0)
        let twit = twitDataSource.twits[rowIndex]
        cell.twitTextLabel.text = twit.text
        cell.twitDateLabel.text = twit.date.toString()
        return cell
    }

    //MARK: private

    func saveTwit(newTwit:String)
    {
        twitDataSource.sendTwit(newTwit, completion: { err in
            GCDDispatchMain({ () -> () in
                if err == nil
                {
                    self.presentedViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.fetchTwits()
                    })
                }
            })
        })
    }

    func didSignIn()
    {
        fetchTwits()
    }

    func fetchTwits()
    {
        self.refreshControl?.beginRefreshing()
        twitDataSource.fetchNewTwits { newTwitsFound, error in
            GCDDispatchMain({ () -> () in
                self.refreshControl?.endRefreshing()
                if newTwitsFound && error == nil
                {
                    self.tableView.reloadData()
                }
            })
        }
    }
}
