//
//  PlayerController.swift
//  demoapp
//
//  Created by Jason Sekhon on 2017-09-22.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import UIKit
import AVKit
import CoreAudioKit
import MediaPlayer

class PlayerController: UIViewController {
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var Volume: UISlider!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var activityText: UILabel!
    @IBOutlet weak var activityImage: UIButton!
    // Instantiate a new music player
    let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    let volumeSlider = (MPVolumeView().subviews.filter { NSStringFromClass($0.classForCoder) == "MPVolumeSlider" }.first as! UISlider)
    var timer: Timer!
    var activity: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        updateSlider()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func updateSlider(){
        Volume.setValue(volumeSlider.value, animated: true)
    }
    
    func updateSongTitle(){
        nowPlayingLabel.text = (myMediaPlayer.nowPlayingItem?.title)!
        artistLabel.text = (myMediaPlayer.nowPlayingItem?.artist!)!
        albumImage.image = myMediaPlayer.nowPlayingItem?.artwork?.image(at: (albumImage.bounds.size))
    }
    
    @IBAction func sliderVolume(_ sender: AnyObject) {
        volumeSlider.setValue(sender.value, animated: false)
    }
    
    @IBAction func playOrPause(_ sender: Any) {
        if (myMediaPlayer.playbackState.rawValue == 1){
            myMediaPlayer.pause()
            playBtn.setImage(UIImage(named: "icons8-Circled Play_2"), for: .normal)
        } else if (myMediaPlayer.playbackState.rawValue == 2 || myMediaPlayer.playbackState.rawValue == 0){
            myMediaPlayer.play()
            playBtn.setImage(UIImage(named: "icons8-Pause Button_2"), for: .normal)
        }
        updateSongTitle()
    }
    
    @IBAction func next(_ sender: Any) {
        myMediaPlayer.skipToNextItem()
        updateSongTitle()
    }
    
    @IBAction func prev(_ sender: Any) {
        myMediaPlayer.skipToPreviousItem()
        updateSongTitle()
    }
    
}
