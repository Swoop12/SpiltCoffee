//
//  RecepieVideoView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 11/8/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import AVKit

class RecepieVideoView: UIView {
    
    var videoUrlString: String?{
        didSet{
            runVideo()
        }
    }
    
    weak var viewController: UIViewController?
    
    func runVideo(){
        guard let videoUrlString = videoUrlString, let path = Bundle.main.path(forResource: videoUrlString, ofType: "mp4") else {return}
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        player?.play()
        player?.volume = 0
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    
    
    var playerLayer: AVPlayerLayer{
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get{
            return playerLayer.player
        }
        set{
            playerLayer.player = newValue
        }
    }
    
    override class var layerClass: AnyClass{
        return AVPlayerLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tap = UITapGestureRecognizer(target: self, action: #selector(wasTapped))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(wasDoubleTapped))
        
        doubleTap.numberOfTapsRequired = 2
        tap.require(toFail: doubleTap)
        
        addGestureRecognizer(tap)
        addGestureRecognizer(doubleTap)
        
        player?.volume = 0
        
    }
    
    func wasTapped(){
        player?.timeControlStatus.rawValue == 0 ? player?.play() : player?.pause()
    }
    
    func wasDoubleTapped(){
        guard let player = player else { return }
        viewController?.presentAVPlayerVC(with: player)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero) { (_) in
                self.player?.play()
            }
        }
    }
}
