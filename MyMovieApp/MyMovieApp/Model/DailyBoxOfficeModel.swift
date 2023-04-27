////
////  DailyBoxOfficeModel.swift
////  MyMovieApp
////
////  Created by MackBook Pro on 2023/04/26.
////

//struct DailyBoxOffice: Decodable {
//    let boxOfficeResult: BoxOfficeResult
//}
//
//// MARK: - BoxOfficeResult
//struct BoxOfficeResult: Decodable {
//    let boxofficeType, showRange: String
//    let dailyBoxOfficeList: [DailyBoxOfficeList]?
//}
//
//// MARK: - DailyBoxOfficeList
//struct DailyBoxOfficeList: Decodable {
//    let rnum, rank, rankInten: String?
//    let rankOldAndNew: RankOldAndNew?
//    let movieCD, movieNm, openDt, salesAmt: String
//    let salesShare, salesInten, salesChange, salesAcc: String
//    let audiCnt, audiInten, audiChange, audiAcc: String
//    let scrnCnt, showCnt: String
//
//    enum CodingKeys: String, CodingKey {
//        case rnum, rank, rankInten, rankOldAndNew
//        case movieCD
//        case movieNm, openDt, salesAmt, salesShare, salesInten, salesChange, salesAcc, audiCnt, audiInten, audiChange, audiAcc, scrnCnt, showCnt
//    }
//}
//
//enum RankOldAndNew: String, Decodable {
//    case old = "OLD"
//}
