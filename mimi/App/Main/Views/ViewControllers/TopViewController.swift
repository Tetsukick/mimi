import UIKit
import RxSwift
import RxCocoa

final class TopViewController : UIViewController {
    
    private let viewModel: TopViewModelType = TopViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var recordStartButton: UIButton!
    
    private let segueIdentifierShowRecordView = "showRecordView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordStartButton
            .rx
            .tap
            .bind(to: viewModel.inputs.pressedRecordStartButton)
            .disposed(by: disposeBag)
        
        // inputs
        viewModel.inputs.pressedRecordStartButton
            .subscribe(onNext: { [weak self]  _ in
                    guard let strongSelf = self else { fatalError() }
                    strongSelf.performSegue(withIdentifier: strongSelf.segueIdentifierShowRecordView, sender: nil)
                })
            .disposed(by: disposeBag)
         
        /* view のアクションをviewModelに通知
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
}

