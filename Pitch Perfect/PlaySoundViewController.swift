//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by André Servidoni on 8/22/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioPath : NSURL!
    var receivedAudio : RecordedAudio!

    var audioPlayer : AVAudioPlayer!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    
    var pitch : Float!
    var reverb : Float!
    
    let TYPE_PITCH = 1
    let TYPE_REVERB = 2
    
    // variable to enable or not the debug prints
    // of this view controller
    let debug = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePath, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePath, error: nil)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: action functions
    
    @IBAction func playSlowSound(sender : UIButton) {
        print("play slow sound")
        playSoundWithRate(0.5)
    }
    
    @IBAction func playFastSound(sender : UIButton) {
        print("play fast sound")
        playSoundWithRate(2.0)
    }
    
    @IBAction func playSoundAsDarthVader(sender: UIButton) {
        print("play sound as darth vader")
        pitch = -1000
        playSoundWithNodeOfType(TYPE_PITCH)
    }
    
    @IBAction func playSoundAsChipmunk(sender: UIButton) {
        print("play sound as chipmunk")
        pitch = 1000
        playSoundWithNodeOfType(TYPE_PITCH)
    }
    
    @IBAction func playReverbWetSound(sender: UIButton) {
        print("play wet reverb sound")
        reverb = 100
        playSoundWithNodeOfType(TYPE_REVERB)
    }
    
    @IBAction func playReverbDrySound(sender: UIButton) {
        print("play dry reverb sound")
        reverb = 0
        playSoundWithNodeOfType(TYPE_REVERB)
    }
    
    @IBAction func stopPlaying(sender : UIButton) {
        print("stop playing sound")
        stopAudios()
    }

    // MARK: private functions
    
    private func connectAudioUnitOf(type : Int, withPlayNode node : AVAudioPlayerNode) {
        
        // audio time pitch
        if(type == TYPE_PITCH) {
            
            let audioPitchEffect = AVAudioUnitTimePitch()
            audioPitchEffect.pitch = pitch
            audioEngine.attachNode(audioPitchEffect)
            
            audioEngine.connect(node, to: audioPitchEffect, format: nil)
            audioEngine.connect(audioPitchEffect, to: audioEngine.outputNode, format: nil)
        }
        // audio reverb
        else if(type == TYPE_REVERB) {
            
            let audioReverbNode = AVAudioUnitReverb()
            audioReverbNode.wetDryMix = reverb
            audioEngine.attachNode(audioReverbNode)
            
            audioEngine.connect(node, to: audioReverbNode, format: nil)
            audioEngine.connect(audioReverbNode, to: audioEngine.outputNode, format: nil)
        }
        
    }
    
    private func playSoundWithRate(rate : Float) {
        stopAudios()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    private func playSoundWithNodeOfType(type : Int) {
        stopAudios()
        
        let audioPlayNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayNode)
        
        connectAudioUnitOf(type, withPlayNode: audioPlayNode)
        
        audioPlayNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayNode.play()
    }
    
    private func stopAudios() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    private func print(message : String) {
        if(debug) {
            println(message)
        }
    }
}
