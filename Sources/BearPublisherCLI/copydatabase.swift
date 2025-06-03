// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.
import Foundation

/// Copies database to the app containers folder.
/// This needs to be done manually because app sandbox is deactivated in order to prevent asking folder permissions for accessing Bear folder on each launch.
/// Also, this needs to be done because accessing BearDb directly can cause a crash when Bear is opened (because two processes try to open the db at the same time)
/// By accessing a copy we circumvent this problem.
func copyDatabase() throws {
    let fm = FileManager.default
    let destinationPath = NSString(string: "~/Library/Containers/lat.cristian.Renard/Data/Applications/").expandingTildeInPath
    let destinationURL = URL(fileURLWithPath: destinationPath).appendingPathComponent("database.sqlite")
    
    let sourcePath = "/Users/\(NSUserName())/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/database.sqlite"

    if fm.fileExists(atPath: destinationURL.relativePath) {
        try fm.removeItem(at: destinationURL)
        try fm.copyItem(atPath: sourcePath, toPath: destinationURL.relativePath)
    } else {
        try fm.createDirectory(atPath: destinationPath, withIntermediateDirectories: true, attributes: nil)
        try fm.copyItem(atPath: sourcePath, toPath: destinationURL.relativePath)
    }
}
