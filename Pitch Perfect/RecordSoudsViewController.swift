//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by André Servidoni on 8/20/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordAudioLabel: UILabel!
    @IBOutlet weak var recordStopButton: UIButton!
    @IBOutlet weak var recordPauseButton: UIButton!
    @IBOutlet weak var recordResumeButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var dirPath : String!
    var recordedAudio : RecordedAudio!
    
    // variable to enable or not the debug prints
    // of this view controller
    let debug = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        updateUIwith("Tap to Record", andVisibility: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "stopRecordingSegue") {
            
            let playSoundViewController:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data:RecordedAudio = sender as! RecordedAudio
            
            playSoundViewController.receivedAudio = data
        }
    }
    
    // MARK: action functions
    
    @IBAction func pauseRecordAudio(sender: UIButton) {
        print("pause recording!")
        audioRecorder.pause()
        
        updateUIwith("Record paused", andVisibility: true)
        recordResumeButton.hidden = false
    }
    
    @IBAction func resumeRecordAudio(sender: UIButton) {
        print("resume recording!")
        audioRecorder.record()
        
        updateUIwith("Recording... say something!", andVisibility: false)
        recordResumeButton.hidden = true
    }
    
    @IBAction func startRecordAudio(sender: UIButton) {
        updateUIwith("Recording... say something!", andVisibility: false)
        
        let pathArray = [dirPath, "recorded_audio.wav"]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        print("stop recording!")
        updateUIwith("Audio recorded!", andVisibility: false)
        recordPauseButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    // MARK: delegate functions
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag) {
            recordedAudio = RecordedAudio(fileTitle: recorder.url.lastPathComponent, inPath: recorder.url)
        
            print("record file path: \(recordedAudio.fileTitle)")
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
       
        } else {
            print("failed to record audio!")
            recordStopButton.hidden = true
            recordAudioLabel.hidden = true
        }
    }
    
    // MARK: private functions
    
    private func updateUIwith(text : String, andVisibility visible : Bool) {
        recordAudioLabel.text = text
        recordStopButton.hidden = visible
        recordPauseButton.hidden = visible
    }
    
    private func print(message : String) {
        if(debug) {
            println(message)
        }
    }
}

