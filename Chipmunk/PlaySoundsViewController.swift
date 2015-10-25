//
//  PlaySoundsViewController.swift
//  Chipmunk
//
//  Created by Dave Vo on 10/13/15.
//  Copyright © 2015 avo. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var filePath: String?
    var fileUrl: NSURL?
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
        //            fileUrl = NSURL(fileURLWithPath: filePath)
        //
        //            print(filePath)
        //
        //            audioPlayer = try! AVAudioPlayer(contentsOfURL: fileUrl!)
        //            audioPlayer!.enableRate = true
        //
        //
        //        } else {
        //            print("file not found")
        //        }
        
        if let fileUrl = receivedAudio?.filePathUrl {
            
            print(filePath)
            
            try! audioPlayer = AVAudioPlayer(contentsOfURL: fileUrl)
            audioPlayer.enableRate = true
            
            audioEngine = AVAudioEngine()
            audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
            
        } else {
            print("file not found")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func playFast(sender: UIButton) {
        playAudioAtSpeed(2.0)
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playAudioAtSpeed(0.5)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func playDarthvader(sender: UIButton) {
        playAudioWithPitch(-1000)
    }
    
    func playAudioAtSpeed(speed: Float) {
        audioPlayer.stop() //stop whatever is being played before
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    func playAudioWithPitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let pitchPlayer = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        
        timePitch.pitch = pitch
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format:nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        pitchPlayer.play()
    }
}
