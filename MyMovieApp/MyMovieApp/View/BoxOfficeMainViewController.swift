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

class BoxOfficeListTableViewController: UIViewController{
    
    @IBOutlet private var today: UINavigationItem!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    private let weeklyBoxOfficeListVM = WeeklyBoxOfficeListVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.titleDataBind()
        self.tableViewDataBind()
    }

    //세그웨이처리
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let calenderVC = segue.destination as? CalenderViewController else {
            fatalError("..")
        }
        calenderVC.weaklyBoxOfficeVM = self.weeklyBoxOfficeListVM
    }

    //세그먼트제어
    @IBAction func selectWeekedWeekday(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            self.weeklyBoxOfficeListVM.targetDateInput.onNext(self.today.title!.components(separatedBy: ["-"]).joined())
            self.weeklyBoxOfficeListVM.weekGbInput.onNext("0")
        } else {
            self.weeklyBoxOfficeListVM.targetDateInput.onNext(self.today.title!.components(separatedBy: ["-"]).joined())
            self.weeklyBoxOfficeListVM.weekGbInput.onNext("1")
        }
    }
    
    //tableview에 쓸 데이터를 바인딩함.
    private func tableViewDataBind() {
        self.weeklyBoxOfficeListVM.targetDateInput.onNext("20230101")
        self.weeklyBoxOfficeListVM.weekGbInput.onNext("0")
        self.weeklyBoxOfficeListVM.listOutput
            .bind(to: tableView.rx.items(cellIdentifier: "BoxOfficeListCell")) { (index, item: WeeklyBoxOfficeList, cell: BoxOfficeListCell) in
                cell.setData(item)
            }
            .disposed(by: disposeBag)
    }
    
    //상단 네비 타이틀의 날짜데이터를 바인딩함.
    private func titleDataBind() {
        self.weeklyBoxOfficeListVM.selectDateInput.onNext(Date())
        self.weeklyBoxOfficeListVM.titleOutput
            .bind(to: today.rx.title)
            .disposed(by: disposeBag)
    }
}
