//
//  VGEmbedTableViewController.swift
//  VGPlayerExample
//
//  Created by Vein on 2017/8/9.
//  Copyright © 2017年 Vein. All rights reserved.
//

import UIKit
import VGPlayer
import SnapKit

class VGEmbedTableViewController: UITableViewController, VGPlayerViewDelegate {
    
    
    var player : VGPlayer!
    var playerView : VGEmbedPlayerView!
    var currentPlayIndexPath : IndexPath?
    var smallScreenView : UIView!
    var panGesture = UIPanGestureRecognizer()
    var playerViewSize : CGSize?
    
    var nextCount = 0
    var currentIndex = 0
    var dataScource : [URL] = [URL.init(string: "https://cdn.funtooapp.com/videos/fc4be1ff-05eb-4201-8d9a-d65e8c46af73/mp4/fc4be1ff-05eb-4201-8d9a-d65e8c46af73.mp4")!,
                               URL.init(string:"https://cdn.funtooapp.com/videos/d52a09fa-f50c-4cf9-9bb7-db80a42784d7/mp4/d52a09fa-f50c-4cf9-9bb7-db80a42784d7.mp4")!,
                               URL.init(string: "https://cdn.funtooapp.com/videos/30429d89-0ab6-4761-9fe0-d3f79e7d657e/mp4/30429d89-0ab6-4761-9fe0-d3f79e7d657e.mp4")!,
                    URL.init(string: "https://cdn.funtooapp.com/videos/ba422f39-d7ee-4ba2-b6d6-9c56bc58fe74/mp4/ba422f39-d7ee-4ba2-b6d6-9c56bc58fe74.mp4")!,
                    URL.init(string: "https://cdn.funtooapp.com/videos/3134ca44-fa57-40b7-b23b-c104e74a9e4b/mp4/3134ca44-fa57-40b7-b23b-c104e74a9e4b.mp4")!,
                    URL.init(string: "https://cdn.funtooapp.com/videos/67085f01-0a1e-49de-a33b-4be78d9442ec/mp4/67085f01-0a1e-49de-a33b-4be78d9442ec.mp4")!,
                    URL.init(string: "https://cdn.funtooapp.com/videos/8036b1a7-525e-454f-81c0-f047e1df8b15/mp4/8036b1a7-525e-454f-81c0-f047e1df8b15.mp4")!]
    
//    func getVideos() -> URL{
//        self.dataScource = ["https://cdn.funtooapp.com/videos/fbbce567-5eff-4a46-bf42-cccdc131261f/mp4/fbbce567-5eff-4a46-bf42-cccdc131261f.mp4",
//                            "https://cdn.funtooapp.com/videos/f5c84d18-af5e-4f2d-8108-da44d1381499/mp4/f5c84d18-af5e-4f2d-8108-da44d1381499.mp4",
//                            "https://cdn.funtooapp.com/videos/d0bd7667-c294-4385-9b76-3156af8e46d7/mp4/d0bd7667-c294-4385-9b76-3156af8e46d7.mp4",
//                            "https://cdn.funtooapp.com/videos/717373ac-16ca-4182-bc78-b175c58d61f1/mp4/717373ac-16ca-4182-bc78-b175c58d61f1.mp4",
//                            "https://cdn.funtooapp.com/videos/d54b57ef-bdfb-4d0a-88dc-63f440584cc3/mp4/d54b57ef-bdfb-4d0a-88dc-63f440584cc3.mp4",
//                            "https://cdn.funtooapp.com/videos/08e45af8-faa2-43ef-bb21-62feacb314ec/mp4/08e45af8-faa2-43ef-bb21-62feacb314ec.mp4",
//                            "https://cdn.funtooapp.com/videos/1dd23ef5-7213-4fee-b2db-9f8869af572b/mp4/1dd23ef5-7213-4fee-b2db-9f8869af572b.mp4"]
//        nextCount = nextCount % self.dataScource.count
//        print("count videos", nextCount)
//        let url = URL(string: self.dataScource[nextCount])!
//        nextCount += 1
//        return url
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Embed in cell of tableView"
        addTableViewObservers()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.removeFromSuperview()
        player.cleanPlayer()
        currentPlayIndexPath = nil
    }
    
    deinit {
        player.cleanPlayer()
        removeTableViewObservers()
    }
    
    func configurePlayer() {
        playerView = VGEmbedPlayerView()
        player = VGPlayer(playerView: playerView)
        player.backgroundMode = .suspend
        playerView.displayControlView(false)
        player?.delegate = self
        player.play()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        self.playerView.addGestureRecognizer(panGesture)
        self.player.delegate = self
        self.player.displayView.delegate = self
    }
    
    @objc func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let point = gesture.translation(in: self.playerView)
        if let gestureView = gesture.view {
            if gesture.state == .ended {
                print("traslatedPoint", point.y)
                if point.y < -50 && self.currentPlayIndexPath!.row < (self.dataScource.count - 1) {
                    self.currentPlayIndexPath = IndexPath.init(row: self.currentPlayIndexPath!.row + 1, section: 0)
 
                }
                
                if point.y > 50 && self.currentPlayIndexPath!.row > 0 {
         
                    self.currentPlayIndexPath = IndexPath.init(row: self.currentPlayIndexPath!.row - 1, section: 0)
                }
                
                UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                    
                        print("count videos io", self.currentPlayIndexPath!.row)
                    self.tableView?.scrollToRow(at: self.currentPlayIndexPath!, at: .middle, animated: false)
                }, completion: { finished in
//                    self.player.replaceVideo(self.dataScource[self.currentPlayIndexPath!.row])
//                    self.player.play()
                })
            }
        }
    }
    
    func addTableViewObservers() {
        let options = NSKeyValueObservingOptions([.new, .initial])
        tableView?.addObserver(self, forKeyPath: #keyPath(UITableView.contentOffset), options: options, context: nil)
    }
    
    func removeTableViewObservers() {
        tableView?.removeObserver(self, forKeyPath: #keyPath(UITableView.contentOffset))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataScource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! VGVideoCell
        cell.indexPath = indexPath
        cell.nextCallBack = ({ [weak self] (indexPath: IndexPath?) -> Void in
            guard let strongSelf = self else { return }
            
        })
        self.playerViewSize = CGSize(width: 100, height: 200)
        self.currentPlayIndexPath = indexPath
        
        self.addPlayer(cell, indexPath: indexPath)
        return cell
    }
    
    func addPlayer(_ cell: UITableViewCell, indexPath: IndexPath) {
        if player != nil {
            player.cleanPlayer()
        }
        configurePlayer()
        cell.contentView.addSubview(player.displayView)
        player.displayView.snp.makeConstraints {
            $0.edges.equalTo(cell)
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            self.tableView?.scrollToRow(at: self.currentPlayIndexPath!, at: .middle, animated: false)
        }, completion: { finished in
            self.player.replaceVideo(self.dataScource[self.currentPlayIndexPath!.row])
            self.player.play()
        })
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
 
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

extension VGEmbedTableViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UITableView.contentOffset) {
            if let playIndexPath = currentPlayIndexPath {
                
                if let cell = tableView.cellForRow(at: playIndexPath) {
                    if player.displayView.isFullScreen { return }
                    let visibleCells = tableView.visibleCells
                    if visibleCells.contains(cell) {
                        cell.contentView.addSubview(player.displayView)
                        player.displayView.snp.remakeConstraints {
                            $0.edges.equalTo(cell)
                        }
                        player.play()
                    } else {
                    }
                } else {
                }
            }
        }
    }
}


extension VGEmbedTableViewController: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        if state == .playFinished {
            if self.currentPlayIndexPath!.row < (self.dataScource.count - 1) {
                self.currentPlayIndexPath!.row += 1
                UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                    self.tableView?.scrollToRow(at: self.currentPlayIndexPath!, at: UITableView.ScrollPosition.middle, animated: false)
                }, completion: { finished in
                    self.player.replaceVideo(self.dataScource[self.currentPlayIndexPath!.row])
                    self.player.play()
                })
            }
        }
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
}
