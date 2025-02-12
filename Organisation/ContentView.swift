import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext // Get Core Data context

    var body: some View {
        MainView(context: viewContext) // Pass the correct context
    }
}

