//
//  JobOfferListDao.swift
//  DrawerMenu-Sample
//
//  Created by kawaharadai on 2018/08/15.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

final class JobOfferListDao {
    
    static let shered = JobOfferListDao()
    private var db: FMDatabase?
    
    /// ローカルからDBデータを取得する
    ///
    /// - Returns: DBデータ
    func sqliteDB() -> FMDatabase {
        let dbFilePath = Bundle.main.path(forResource: "job", ofType: "sqlite3")
        return FMDatabase(path: dbFilePath)
    }
    
    /// DBオブジェクトを返す、ない場合は取得する
    func getDB() -> FMDatabase {
        return self.db ?? self.sqliteDB()
    }
    
    /// 指定した条件でローカルのDBファイルからレコードを全件取得
    ///
    /// - Parameters:
    ///   - tableName: テーブル名
    ///   - sort: ソート対象
    ///   - acsOrDesc: 昇順or降順
    /// - Returns: JobOfferモデルの配列
    func selectAll(tableName: String, sort: String, ascOrDesc: String) -> [JobOffer] {
        let db = getDB()
        let sql = "SELECT * FROM \(tableName) ORDER BY \(sort) \(ascOrDesc)"
        var jobOffers: [JobOffer] = []
        db.open()
        let results = db.executeQuery(sql, withArgumentsIn: [])
        if let results = results {
            while results.next() {
                let jobOffer = JobOffer(result: results)
                jobOffers.append(jobOffer)
            }
        }
        db.close()
        // 会社名を取得
        jobOffers.forEach {
            $0.companyName = selectCompanyName(tableName: "company_master", jobOffer: $0)
        }
        return jobOffers
    }
    
    private func selectCompanyName(tableName: String, jobOffer: JobOffer) -> String {
        let db = getDB()
        let sql = "SELECT * FROM \(tableName) WHERE company_no = ?"
        var object = ""
        db.open()
        let results = db.executeQuery(sql, withArgumentsIn: [jobOffer.companyNumber])
        if let results = results {
            while results.next() {
                object = results.string(forColumn: "company_name") ?? ""
            }
        }
        db.close()
        return object
    }
}
