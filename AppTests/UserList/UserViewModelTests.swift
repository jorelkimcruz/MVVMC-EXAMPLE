//
//  UserViewModelTests.swift
//  AppTests
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Nimble
import Quick
import CoreData

@testable import App

class UserViewModelTestsSpec: QuickSpec {
    override func spec() {
        describe("Given that the app opens") {
            var viewModel: UserViewModel!
            var serviceMock: APIServiceMock!
            var coreStorageMock: CoreDataStorage!
            var userStorageManager: UserStorageManger!
            
            
            context("and a requests for user list is established") {
                beforeEach {
                    coreStorageMock = CoreDataStorage()
                    serviceMock = APIServiceMock(response: .success, responseFile: "UserList", errorResponseFile: nil)
                    userStorageManager = UserStorageManger(container: coreStorageMock.persistentContainer)
                    viewModel = UserViewModel(service: serviceMock, persistence: userStorageManager)
                }
                
                it("should successfully get users data") {
                    viewModel.requestUserListFromServer()
                    expect(viewModel.userData).toNot(beNil())
                }
                
                it("should sync user data to persistence store") {
                    viewModel.requestUserListFromServer()
                    viewModel.syncUserListToPersistence(data: viewModel.userData)
                    viewModel.getUserListFromPersistence()
                    expect(viewModel.userList).toNot(beEmpty())
                }
            }
            
            context("and a request for user list failed") {
                beforeEach {
                    coreStorageMock = CoreDataStorage()
                    serviceMock = APIServiceMock(response: .systemError, responseFile: nil, errorResponseFile: nil, errorCode: 423)
                    userStorageManager = UserStorageManger(container: coreStorageMock.persistentContainer)
                    viewModel = UserViewModel(service: serviceMock, persistence: userStorageManager)
                }
                
                it("should not update user list") {
                    viewModel.requestUserListFromServer()
                    expect(viewModel.userList).to(beNil())
                }
            }
        }
    }
}
