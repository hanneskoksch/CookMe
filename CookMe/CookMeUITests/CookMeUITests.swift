//
//  CookMeUITests.swift
//  CookMeUITests
//
//  Created by Torben Ziegler on 11.05.21.
//

import XCTest

// In order to run this test properly, you need to disable the "connect to hardware keyboard" option in your simulators settings.
// Go to I/O --> Keyboard --> disable "connect to hardware keyboard"
class CookMeUITests: XCTestCase {
    
    var app: XCUIApplication = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {

        // Launch application
        app = XCUIApplication()
        app.launch()
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        

        
        // Create Category
        app.navigationBars["Kategorien"].buttons["plus"].tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Name der Kategorie"]/*[[".cells[\"Name der Kategorie\"].textFields[\"Name der Kategorie\"]",".textFields[\"Name der Kategorie\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        type(word: "Salate")
        
        app.tables.containing(.cell, identifier:"Tippen um Bild auszuwählen").element.swipeUp()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Kategorie erstellen"]/*[[".cells[\"Kategorie erstellen\"].buttons[\"Kategorie erstellen\"]",".buttons[\"Kategorie erstellen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        // Enter Category
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Salate"]/*[[".cells[\"Salate\"].buttons[\"Salate\"]",".buttons[\"Salate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        // Create Recipe
        app.navigationBars["Salate"].buttons["plus"].tap()
        
        let tablesQuery2 = tablesQuery
        tablesQuery2/*@START_MENU_TOKEN@*/.textFields["Name des Rezeptes"]/*[[".cells[\"Name des Rezeptes\"].textFields[\"Name des Rezeptes\"]",".textFields[\"Name des Rezeptes\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        type(word: "Griechischer salat")
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards.buttons[\"Return\"]",".buttons[\"Return\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let beschreibungTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Beschreibung"]/*[[".cells[\"Beschreibung\"].textFields[\"Beschreibung\"]",".textFields[\"Beschreibung\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        beschreibungTextField.tap()
        type(word: "Gut zum abendbrot")
        returnButton.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Anzahl Personen"]/*[[".cells[\"Anzahl Personen\"].textFields[\"Anzahl Personen\"]",".textFields[\"Anzahl Personen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        type(word: "3")
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 0)
        element.swipeUp()
        
        let zeitaufwandInMinutenTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Zeitaufwand in Minuten"]/*[[".cells[\"Zeitaufwand in Minuten\"].textFields[\"Zeitaufwand in Minuten\"]",".textFields[\"Zeitaufwand in Minuten\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        zeitaufwandInMinutenTextField.tap()
        type(word: "10")
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Neue Zutat"]/*[[".cells[\"Neue Zutat, Hinzufügen\"].textFields[\"Neue Zutat\"]",".textFields[\"Neue Zutat\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        type(word: "Tomaten")
        let hinzufGenButton = tablesQuery2.cells["Hinzufügen"].buttons["Hinzufügen"]
        hinzufGenButton.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Neuer Schritt"]/*[[".cells[\"Neuer Schritt, Hinzufügen\"].textFields[\"Neuer Schritt\"]",".textFields[\"Neuer Schritt\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        type(word: "Alles gut mischen")
        hinzufGenButton.tap()
        
        tablesQuery2.staticTexts["ANLEITUNG"].swipeUp()
        
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Rezept erstellen"]/*[[".cells[\"Rezept erstellen\"].buttons[\"Rezept erstellen\"]",".buttons[\"Rezept erstellen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        // open recipe
        tablesQuery.buttons["Griechischer salat"].tap()
        app.buttons["star"].tap()

       
        // switch to favorites
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Favoriten"].tap()
        
        // open recipe
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Griechischer salat"]/*[[".cells[\"Griechischer salat\"].buttons[\"Griechischer salat\"]",".buttons[\"Griechischer salat\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        // add ingredient to shoppinglist
        //tablesQuery/*@START_MENU_TOKEN@*/.buttons["text.badge.checkmark"]/*[[".cells[\"Tomaten, text.badge.checkmark\"].buttons[\"text.badge.checkmark\"]",".buttons[\"text.badge.checkmark\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.scrollViews.otherElements.buttons["text.badge.checkmark"].tap()
        // switch to shoppinglist
        tabBar.buttons["Einkaufsliste"].tap()
        // add item to shoppinglist
        app.navigationBars["Einkaufsliste"].buttons["plus"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Name der Zutat"]/*[[".cells[\"Name der Zutat\"].textFields[\"Name der Zutat\"]",".textFields[\"Name der Zutat\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        type(word: "Butter")
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Zutat hinzufügen"]/*[[".cells[\"Zutat hinzufügen\"].buttons[\"Zutat hinzufügen\"]",".buttons[\"Zutat hinzufügen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                                

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    
    // Types given word with the virtual keyboard (saves lots of lines)
    func type(word: String) {
        for char in word {
            if char == " " {
                let aKey = app.keys["Leerzeichen"]
                aKey.tap()
            } else {
                let aKey = app.keys[String(char)]
                aKey.tap()
            }
        }
        //*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards",".buttons[\"Umschalt\"]",".buttons[\"shift\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
