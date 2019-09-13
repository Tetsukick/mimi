import RxSwift

protocol RecordViewModelInputs {
    /* viewからのアクションを定義する
     var pressedCloseButton: PublishSubject<Void> { get }
     func request(param: Int)
     func doSomething()
     */
}

protocol RecordViewModelOutputs {
    /*　modelからの処理結果をviewへ通知するプロパティまたはメソッドを定義する
     var getRequestState: Variable<GetRequestState> { get }
     */
    
}

protocol RecordViewModelType {
    var inputs: RecordViewModelInputs { get }
    var outputs: RecordViewModelOutputs { get }
}

final class RecordViewModel: RecordViewModelType, RecordViewModelInputs, RecordViewModelOutputs {
    private let model = RecordModel()
    private let disposeBag = DisposeBag()
    
    var inputs: RecordViewModelInputs { return self }
    var outputs: RecordViewModelOutputs { return self }
    
    //    let pressedButton = PublishSubject<Void>()
    
    init() {
        /* Modelからの処理結果を受け取り、view側へ通知する
         ※requestStateの状態を購読する。（requestStateの値が代入されたタイミングで呼ばれる）
         requestStateの状態を変更して、ViewControllerで状態の変化を購読できるようにする
         model.requestState
         .asObservable()
         .subscribe(onNext: { [getRequestState] requestState in
         switch requestState {
         case .success:
         getRequestState.value = .success(message: "hoge")
         break
         case .error:
         getRequestState.value = .failure
         break
         default: break
         }
         })
         .disposed(by: disposeBag)
         */
        
    }
    
    /*
     func request(param: Int) {
     model.request(param: param)
     }
     
     func doSomething() {
     model.doSomething()
     }
     */
    
}

