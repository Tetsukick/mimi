import UIKit
import RxSwift
import RxCocoa
import AVFoundation

final class RecordViewController : UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    private let viewModel: RecordViewModelType = RecordViewModel()
    private let disposeBag = DisposeBag()
    
    fileprivate var audioRecorder: AVAudioRecorder?
    fileprivate var audioPlayer: AVAudioPlayer!
    fileprivate var isRecording = BehaviorRelay<Bool>(value: false)
    fileprivate var isPlaying = false
    
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isRecording
            .asObservable()
            .subscribe(onNext: { [weak self] isRecording in
                guard let strongSelf = self else { return }
                strongSelf.startPauseButton.setImage(isRecording ? #imageLiteral(resourceName: "stop_btn.pdf") : #imageLiteral(resourceName: "start_btn.pdf"), for: .normal)
            })
            .disposed(by: disposeBag)
        
        record()
        
        /* UI部品と紐付ける（例：ボタンとpressedButtonを結びつける）
         button
         .rx
         .tap
         .bind(to: viewModel.inputs.pressedButton)
         .disposed(by: disposeBag)
         */
        
        // inputs
        /* view のアクションをviewModelに通知
         viewModel.inputs.pressedButton
         .subscribe(onNext: { [weak self]  _ in
         guard let strongSelf = self else { fatalError() }
         strongSelf.viewModel.inputs.request(param: x)
         })
         .disposed(by: disposeBag)
         
         viewModel.inputs.doSomething()
         */
        
        
        // outputs
        /* viewModelからの通知を受け取る
         ※viewModelのgetRequestStateの状態を購読する。（getRequestStateの値が代入されたタイミングで呼ばれる）
         viewModel.outputs.getRequestState
         .asObservable
         .subscribe(onNext: { [weak self] state in
         guard let strongSelf = self else { fatalError() }
         switch state {
         case .success(let message):
         成功時の処理
         break
         case .failure:
         失敗時の処理
         break
         default: break
         }
         })
         .disposed(by: disposeBag)
         */
        
    }
    
    @IBAction func tappedStartPauseButton(_ sender: Any) {
        if isRecording.value {
            pause()
        } else {
            record()
        }
    }
    
    @IBAction func tappedStopButton(_ sender: Any) {
        if let recorder = audioRecorder {
            recorder.stop()
        }
        play()
    }
    
    func record() {
        
        if let recorder = audioRecorder, recorder.isRecording {
            recorder.record()
        } else {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSession.Category.playAndRecord)
                try session.setActive(true)
            } catch {
                print("record error: failed set session")
                isRecording.accept(false)
                return
            }

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            do {
                audioRecorder = try AVAudioRecorder(url: getURL(), settings: settings)
                audioRecorder?.delegate = self
                audioRecorder?.record()
            } catch {
                print("record error: failed create recorder")
                isRecording.accept(false)
                return
            }
        }

        isRecording.accept(true)
    }
    
    func pause() {
        audioRecorder?.pause()
        isRecording.accept(false)
    }
    
    func play() {
        audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
        audioPlayer.delegate = self
        audioPlayer.play()
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
    }
}

