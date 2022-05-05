//
//  SplashViewControllerTests.swift
//  hello-worldTests
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import XCTest
@testable import hello_world

class SplashViewControllerTests: XCTestCase {

    var splashViewController: SplashViewController!
    
    override func setUpWithError() throws {
        self.splashViewController = UIStoryboard(name: "Splash", bundle: nil).instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController
        guard let _ = splashViewController else {
            return XCTFail("Failed to instantiate SplashViewController")
        }
        self.splashViewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        self.splashViewController = nil
    }
    
    func testTitleLabels() throws {
        XCTAssertTrue(self.splashViewController.titleLabel.text == R.string.localizable.splash_title_label(), "Title text does not match.")
        XCTAssertTrue(self.splashViewController.subtitleLabel.text == R.string.localizable.splash_subtitle_label(), "Subtitle text does not match.")
        
    }

    func testNavigateToFlightsList() throws {
        let identifiers = self.getSeguesIdentifier()
        
        XCTAssertEqual(identifiers.count, 1, "Segue count should be one.")
        XCTAssertTrue(identifiers.contains("UsersSegue"), "Segue UsersSegue should exist.")
    }
    
    // MARK: - Function to get segues identifier
    func getSeguesIdentifier() -> [String] {
        return (self.splashViewController.value(forKey: "storyboardSegueTemplates") as? [AnyObject])?.compactMap({ $0.value(forKey: "identifier") as? String }) ?? []
    }
}
