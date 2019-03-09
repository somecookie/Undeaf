//
//  ViewController.swift
//  Starthack19
//
//  Created by Lionel Pellier on 09/03/2019.
//  Copyright © 2019 Lionel Pellier. All rights reserved.
//

import UIKit
import Speech

class AudioViewController: UIViewController {

    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var resultContainer: UIView!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultContainer.layer.cornerRadius = 10.0
        resultContainer.layer.shadowColor = UIColor(hexString: "004B68").cgColor
        resultContainer.layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
        resultContainer.layer.shadowRadius = 4.0
        resultContainer.layer.shadowOpacity = 0.4
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @IBAction func buttonTapped(_ sender: Any) {
        if isRecording == true {
            audioEngine.stop()
            recognitionTask?.cancel()
            isRecording = false
            startStopBtn.backgroundColor = .white
            audioEngine.inputNode.removeTap(onBus: 0)
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            startStopBtn.backgroundColor = .red
        }
    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AudioViewController: SFSpeechRecognizerDelegate{
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                self.resultLbl.text = bestString
                
            }
        })
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.startStopBtn.isEnabled = true
                case .denied:
                    self.startStopBtn.isEnabled = false
                    self.resultLbl.text = "User denied access to speech recognition"
                case .restricted:
                    self.startStopBtn.isEnabled = false
                    self.resultLbl.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.startStopBtn.isEnabled = false
                    self.resultLbl.text = "Speech recognition not yet authorized"
                }
            }
        }
    }
}

