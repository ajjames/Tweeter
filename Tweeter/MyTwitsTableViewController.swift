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
        refreshControl!.tintColor = .white
        refreshControl!.addTarget(self, action: #selector(fetchTwits), for: UIControlEvents.valueChanged)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if User.currentUser == nil
        {
            performSegue( withIdentifier: "showSignIn", sender: nil)
        }
        else
        {
            fetchTwits()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewTwit"
        {
            if let destinationViewController = segue.destination as? NewTwitViewController
            {
                destinationViewController.saveTwitClosure = self.saveTwit
            }
        }
        else if segue.identifier == "showSignIn"
        {
            User.signout()
            tableView.reloadData()
            if let destinationViewController = segue.destination as? SignInViewController
            {
                destinationViewController.signedInClosure = self.didSignIn
            }
        }
    }

    //MARK: UITableViewController

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return twitDataSource.twits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TwitTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "twitCell") as! TwitTableViewCell
        let rowIndex = max(twitDataSource.twits.count - indexPath.row - 1,0)
        let twit = twitDataSource.twits[rowIndex]
        cell.twitTextLabel.text = twit.text
        cell.twitDateLabel.text = twit.date.toString()
        return cell
    }

    //MARK: private

    func saveTwit(newTwit:String)
    {
        do {
            try twitDataSource.sendTwit(newTwit: newTwit, completion: {
                GCDDispatchMain {
                    self.presentedViewController?.dismiss(animated: true) {
                        self.fetchTwits()
                    }}
            })
        } catch {
            // Handle error
        }
    }

    func didSignIn()
    {
        fetchTwits()
    }

    @objc func fetchTwits()
    {
        self.refreshControl?.beginRefreshing()
        do {
            try twitDataSource.fetchNewTwits { newTwitsFound in
                GCDDispatchMain {
                    self.refreshControl?.endRefreshing()
                    if newTwitsFound {
                        self.tableView.reloadData()
                    }
                }
            }
        } catch {
            // Handle error
        }
        
    }
}
