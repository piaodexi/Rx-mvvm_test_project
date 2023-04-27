//
//  BoxOfficeListCell.swift
//  MyMovieApp
//
//  Created by deokhee park on 2023/04/16.
//
import UIKit

class BoxOfficeListCell: UITableViewCell {
    
    @IBOutlet weak var movieNm: UILabel!
    @IBOutlet weak var movieDt: UILabel!
    @IBOutlet weak var movieRank: UILabel!
    
    //셀 셋팅 
    func setData(_ data: WeeklyBoxOfficeList) { 
        movieNm.text = data.movieNm
        movieDt.text = data.openDt
        movieRank.text = data.rank
    }
}
