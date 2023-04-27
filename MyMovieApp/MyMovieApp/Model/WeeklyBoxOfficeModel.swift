//
//  BoxOfficeListModel.swift
//  MyMovieApp
//
//  Created by deokhee park on 2023/04/16.
//

// MARK: - weeklyBoxOffice
struct WeeklyBoxOffice: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Decodable {
    let boxofficeType, showRange, yearWeekTime: String
    let weeklyBoxOfficeList: [WeeklyBoxOfficeList]
}

// MARK: - WeeklyBoxOfficeList
struct WeeklyBoxOfficeList: Decodable {
    let rnum, rank, rankInten: String
    let rankOldAndNew: RankOldAndNew
    let movieCD, movieNm, openDt, salesAmt: String
    let salesShare, salesInten, salesChange, salesAcc: String
    let audiCnt, audiInten, audiChange, audiAcc: String
    let scrnCnt, showCnt: String

    enum CodingKeys: String, CodingKey {
        case rnum, rank, rankInten, rankOldAndNew
        case movieCD = "movieCd"
        case movieNm, openDt, salesAmt, salesShare, salesInten, salesChange, salesAcc, audiCnt, audiInten, audiChange, audiAcc, scrnCnt, showCnt
    }
}

enum RankOldAndNew: String, Decodable {
    case new = "NEW"
    case old = "OLD"
}
