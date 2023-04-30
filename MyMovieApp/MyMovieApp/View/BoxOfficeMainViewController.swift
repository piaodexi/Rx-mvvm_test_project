//
//  BoxOfficeListTableViewController.swift
//  MyMovieApp
//
//  Created by deokhee park on 2023/04/16.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
//TODO 일별?박스오피스 추가
//TODO 영화 검색 추가
//TODO 테이블 셀에서 영화 터치시 영화 상세뷰 추가
//TODO 처음 테이블리스트 가져올때 인디케이터 적용, 주간,주말,날짜선택시 인디게이터 적용
//TODO 앱이 처음 시작될때 주간 주말 리스트를 가여오는데 이때 날짜값을 하드코딩해놈. 오늘날짜에서 api를 호출하기에 유효한 날짜로 치환하는 로직작성후 변경작업필요
//TODO 캘린더에서 날짜 선택에서 날짜를 받아올때 일주일 전 주말,주간 날이 아니면 주간,주말 리스트를 받아오는 api를 실행했을때 데이터를 못받아옴.
//이부분을 input (캘린더에서 선택한날짜) output (캘린더에서 선택한날짜가 유효한 날짜이면 api호출) 패턴으로 작성가능할듯 싶은데... ...
//하고는 싶은데...안되면 그냥 유효성 처리 하는 로직 작성해서 처리해보자 ..
//TODO 하드코딩한 파라미터에서 로직 처리하도록 변경필요
/**
 1 . public과 private의 차이점.
 -> 접근제어자의 역활임. public은 모든 파일에서 접근가능 , private는선언한 범위내에서만 사용가능해서 영향도가 해당범위에만 미치지만
 이로 인해 다른코드에서 public을 접근해서 쓸때 만약 값이 의도치 않는 값으로 변경될때에 대한 영향도가 커질 수 있는 차이가 있음.
 
 2. BehaviorSubject와 PublishSubject의 차이점
 -> publishsubject는 초깃값이 없고 구독될때 새로운 이벤트만 전달함. behaviorsubject는 초깃값을 가지며 구독될때 초깃값을 전달하고 이벤트가 오면 이벤트 모두 전달함 . 초깃값이 있다보니 항상값을 방출 할 수 있음
 
 3. 캘린더 컨트롤러에서 박스오피스메인뷰컨트롤러로 데이터를 넘겨줄때 캘린더 뷰모델이 아닌 위클리박스오피스모델을 사용해서 어떻게 처리할것인지.
 -> 위클리박스오피스모델에서 publishSubjectfh 옵저버블하나 만들어서 처리하는것으로 함. 뷰컨트롤러간에 다이렉트로 넘기는 방법에 대해서도 고민을 해봣지만
 지금은 작성한게 없지만 추후 받아오는 날짜에 대한 유효성 처리가 필요하므로 그에 대한 비즈니스 로직을 작성할려면 뷰모델이 필요할테니 뷰모델을 가지는 방향으로
 위클리박스오피스에서 비헤비어서브젝트로 날짜데이터를 체킹할 수 있게 옵저버블을 만들고 초깃값으로 현재날짜를 셋팅해서 뷰가 처음 켜지는 순간엔 초깃값을 쓰고 추후에 날짜데이터가 변경이 되면 변경이 되는 값으로 쓰는
 방향으로 가도 ㄱㅊ을듯
 4. setTitle함수의 이름에 대한 고민과 이것을 뷰모델로 빼서 처리할 방법
 -> 이름은 getToDay로 변경하고 위클리박스오피스뷰모델에 날짜 스트링반환함수작성하고 박스오피스메인뷰컨트롤러에서 가져다 씀
 5. viewdidload같이 이미 구현된 함수를 오버라이드 해서 쓸 경우 super 쓰고 안쓰고에 대한 차이점
 super.viewDidload()를 호출안해도 viewDidLoad()는 호출됨.그러나 부모 클래스 유아이뷰컨트롤러에서 필요한 초기화 작업이 진행이 안될 수도 있음.
 6. 코드 줄맞춤. rxswift는 한줄에 안씀
 */
class BoxOfficeListTableViewController: UIViewController{
    
    @IBOutlet private var today: UINavigationItem!
    @IBOutlet private var tableView: UITableView!
    
    private let weeklyBoxOfficeListVM = WeeklyBoxOfficeListVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.today.title = weeklyBoxOfficeListVM.getToday()
        self.bind(targetDt: "20230415", weekGb: "0")
    }
    
    //segue 전환 처리
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //CalenderViewController 체크
        guard let calenderVC = segue.destination as? CalenderViewController else {
            fatalError("..")
        }
        calenderVC.weaklyBoxOfficeVM.item
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {  calender in
                self.today.title = calender.selectDate
            })
            .disposed(by: disposeBag)
    }
    
    //주간 주말 세그먼트 제어 함수
    @IBAction private func selectWeekedWeekday(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            weeklyBoxOfficeListVM.dataSetUp(targetDt: "20230415", weekGb: "0")
        } else {
            weeklyBoxOfficeListVM.dataSetUp(targetDt: "20230101", weekGb: "1")
        }
    }
    
    //테이블뷰에 데이터 바인딩
    private func bind(targetDt: String, weekGb: String) {
        weeklyBoxOfficeListVM.list.bind(to: tableView.rx.items(cellIdentifier: "BoxOfficeListCell")) { (index, item: WeeklyBoxOfficeList, cell: BoxOfficeListCell) in
            cell.setData(item)
        }.disposed(by: disposeBag)

        weeklyBoxOfficeListVM.dataSetUp(targetDt: targetDt, weekGb: weekGb)
    }
}

