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
    ///   - sort: ソート対象
    ///   - acsOrDesc: 昇順or降順
    /// - Returns: JobOfferモデルの配列
    func selectAll(sort: String, ascOrDesc: String) -> [JobOffer] {
        let db = getDB()
        let sql = """
            SELECT j.job_image_url, j.job_location, j.job_salary, j.job_detail_info, c.company_name
            FROM job_master j
            INNER JOIN company_master c
            ON j.company_no = c.company_no
            ORDER BY \(sort) \(ascOrDesc);
            """
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
        return jobOffers
    }
    
}
