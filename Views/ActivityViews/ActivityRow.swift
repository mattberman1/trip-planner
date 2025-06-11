import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    @Binding var selectedActivity: Activity?
    
    var body: some View {
        Button(action: {
            selectedActivity = activity
        }) {
            ActivityRowView(activity: activity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let activity = Activity(
        title: "Sample Activity",
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        location: Location(name: "Sample Location", latitude: 0, longitude: 0),
        category: .places,
        notes: "Sample notes"
    )
    
    return ActivityRow(
        activity: activity,
        selectedActivity: .constant(activity)
    )
}
