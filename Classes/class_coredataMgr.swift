//
//  class_coredataMgr.swift
//  Booom
//
//  Created by TT on 2017/1/7.
//  Copyright © 2017年 TT. All rights reserved.
//

import Foundation
import CoreData

class class_coredataMgr: NSObject {
    
//    #define kPgEditSdkCoreDataManager_url_ModelUrl      @"CoreDataModelUrl"
//     @property (nonatomic,strong) NSPersistentStoreCoordinator   *mPersistentStoreCoordinator;
//     @property (nonatomic,strong) NSManagedObjectModel           *mManagedObjectModel;
//     @property (nonatomic,strong) NSManagedObjectContext         *mDefaultPrivateQueueContext;
//     
//     @property (nonatomic,strong) NSMutableDictionary *mDicUserInfo;
    
    let kPgEditSdkCoreDataManager_url_ModelUrl = "CoreDataModelUrl"
    let kPgEditSdkCoreDataManager_url_DBUrl = "CoreDataDBUrl"

    private lazy var mDicUserInfo = Dictionary<String, Any>.init()
    private let mlock = class_lock.init()
    
    private var _mPersistentStoreCoordinator: NSPersistentStoreCoordinator!
    var mPersistentStoreCoordinator: NSPersistentStoreCoordinator! {
        
        if self._mPersistentStoreCoordinator == nil {
            
            self.mlock.lockBlock {
                
                if self._mPersistentStoreCoordinator == nil {
                
                    let dbUrl = self.mDicUserInfo[self.kPgEditSdkCoreDataManager_url_DBUrl] as! URL
                    if !class_path.sIsDirectoryOrFileExists(dbUrl) {
                        
                        print("第一次初始化 Coredata 数据库")
                    }
                    
                    let psc = NSPersistentStoreCoordinator.init(managedObjectModel: self.mManagedObjectModel)
                    do {
                        
                        try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbUrl, options: self.gotPersistentStoreOptions())
                        
                    } catch let err {
                        // 错误出现了，删除DB 重建coredata
                        BLogError("Error: \(err)")
                        
                    }
                    
                    self._mPersistentStoreCoordinator = psc
                }
            }
        }
        return self._mPersistentStoreCoordinator
    }
    
    private var _mManagedObjectModel: NSManagedObjectModel!
    var mManagedObjectModel: NSManagedObjectModel! {
        
        if self._mManagedObjectModel == nil {
            
            self.mlock.lockBlock {
        
                if self._mManagedObjectModel == nil {
                
                    let url = self.mDicUserInfo[self.kPgEditSdkCoreDataManager_url_ModelUrl] as! URL
                    self._mManagedObjectModel = NSManagedObjectModel.init(contentsOf: url)
                }
            }
        }
        
        return self._mManagedObjectModel
    }
    
    required init(dbUrl: URL, modelUrl: URL) {
        
        super.init()
        
        self.mDicUserInfo[kPgEditSdkCoreDataManager_url_DBUrl] = dbUrl
        self.mDicUserInfo[kPgEditSdkCoreDataManager_url_ModelUrl] = modelUrl
    }
    
    private func gotPersistentStoreOptions() -> Dictionary<String, Any> {
        
        return [
            NSInferMappingModelAutomaticallyOption:true,
            NSMigratePersistentStoresAutomaticallyOption:true,
            NSSQLitePragmasOption:[
                "synchronous":"OFF"
            ]
        ]
    }
}

class class_ManagedObjectContext: NSManagedObjectContext {
    
    
}
