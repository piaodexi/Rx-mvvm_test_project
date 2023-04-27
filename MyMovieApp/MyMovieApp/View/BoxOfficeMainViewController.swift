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
class BoxOfficeListTableViewController: UIViewController{

    @IBOutlet var today: UINavigationItem!
    @IBOutlet var tableView: UITableView!
    
    let weeklyBoxOfficeListVM = WeeklyBoxOfficeListVM()
    let disposeBag = DisposeBag()
    var calenderVm =  CalenderVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.today.title = setTitle()
        self.bind(targetDt: "20230415", weekGb: "0")
    }
    
    //segue 전환 처리
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //CalenderViewController 체크
        guard let calenderVC = segue.destination as? CalenderViewController else {
            fatalError("..")
        }
        calenderVC.calenderVm.item
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {  calender in
                self.today.title = calender.selectDate
            }).disposed(by: disposeBag)
    }
    
    //주간 주말 세그먼트 제어 함수
    @IBAction func selectWeekedWeekday(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            weeklyBoxOfficeListVM.dataSetUp(targetDt: "20230415", weekGb: "0")
        } else {
            weeklyBoxOfficeListVM.dataSetUp(targetDt: "20230101", weekGb: "1")
        }
    }
    
    //테이블뷰에 데이터 바인딩
    func bind(targetDt: String, weekGb: String) {
        weeklyBoxOfficeListVM.list.bind(to: tableView.rx.items(cellIdentifier: "BoxOfficeListCell")) { (index, item: WeeklyBoxOfficeList, cell: BoxOfficeListCell) in
            cell.setData(item)
        }.disposed(by: disposeBag)

        weeklyBoxOfficeListVM.dataSetUp(targetDt: targetDt, weekGb: weekGb)
    }
    
    //앱 초기실행시 오늘 날짜 셋팅용
    func setTitle() -> String {
        let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         let current_date_string = formatter.string(from: Date())
         return current_date_string
    }
}

