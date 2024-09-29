import SwiftUI

// Define the HomeNavigation enum
enum HomeNavigation: Hashable {
    case firstDetail
    case secondDetail
    case thirdDetail
}

class NavigationModel: ObservableObject {
    @Published var path = NavigationPath()
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeNavigationView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            SettingsNavigationView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }

            ProfileNavigationView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
    }
}

struct HomeNavigationView: View {
    @StateObject private var navigationModel = NavigationModel()

    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            // Move navigationDestination inside the NavigationStack's content
            HomeView()
                .navigationDestination(for: HomeNavigation.self) { destination in
                    switch destination {
                    case .firstDetail:
                        FirstDetailView()
                    case .secondDetail:
                        SecondDetailView()
                    case .thirdDetail:
                        ThirdDetailView()
                    }
                }
        }
        .environmentObject(navigationModel)
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
            NavigationLink("Go to First Detail", value: HomeNavigation.firstDetail)
        }
        .navigationTitle("Home")
    }
}

struct FirstDetailView: View {
    var body: some View {
        VStack {
            Text("First Detail View")
                .font(.largeTitle)
            NavigationLink("Go to Second Detail", value: HomeNavigation.secondDetail)
        }
        .navigationTitle("First Detail")
    }
}

struct SecondDetailView: View {
    var body: some View {
        VStack {
            Text("Second Detail View")
                .font(.largeTitle)
            NavigationLink("Go to Third Detail", value: HomeNavigation.thirdDetail)
        }
        .navigationTitle("Second Detail")
    }
}

struct ThirdDetailView: View {
    @EnvironmentObject var navigationModel: NavigationModel

    var body: some View {
        VStack {
            Text("Third Detail View")
                .font(.largeTitle)
            Button("Go Back to Home") {
                navigationModel.path = NavigationPath()
            }
        }
        .navigationTitle("Third Detail")
    }
}

struct SettingsNavigationView: View {
    var body: some View {
        NavigationStack {
            SettingsView()
        }
    }
}


struct ProfileNavigationView: View {
    @State private var isActive: Bool = false

    var body: some View {
        NavigationView {
            ProfileView(isActive: self.$isActive)
                .navigationBarTitle("Profile", displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures consistent behavior on iPad
    }
}


struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
            NavigationLink("Go to Details", destination: SettingsDetailView())
        }
        .navigationTitle("Settings")
    }
}

struct SettingsDetailView: View {
    var body: some View {
        Text("Settings Detail View")
            .navigationTitle("Settings Details")
    }
}


struct ProfileView: View {
    @Binding var isActive: Bool

    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
            NavigationLink(
                destination: ProfileDetailView(rootIsActive: self.$isActive),
                isActive: self.$isActive
            ) {
                Text("Go to Details")
            }
            .isDetailLink(false) // Ensures the view is pushed onto the stack
        }
        .navigationTitle("Profile")
    }
}



struct ProfileDetailView: View {
    @Binding var rootIsActive: Bool

    var body: some View {
        VStack {
            Text("Profile Detail View")
                .font(.largeTitle)
            NavigationLink(
                destination: ProfileSubDetailView(rootIsActive: self.$rootIsActive)
            ) {
                Text("Go to Sub Detail")
            }
            .isDetailLink(false)
        }
        .navigationTitle("Profile Details")
    }
}


struct ProfileSubDetailView: View {
    @Binding var rootIsActive: Bool

    var body: some View {
        VStack {
            Text("Profile Sub Detail View")
                .font(.largeTitle)
            Button(action: {
                self.rootIsActive = false // Pops to root when set to false
            }) {
                Text("Pop to Root")
            }
        }
        .navigationTitle("Sub Detail")
    }
}


