import SwiftUI

struct EmployeeDetailCell: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var employee: Employee
    @State private var profileImage: UIImage? = nil
    @State private var isEditing = false

    var body: some View {
        VStack {
            HStack {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60)
                }
                VStack(alignment: .leading) {
                    Text("\(employee.name ?? "Unknown")")
                        .font(.title2)
                    Text("\(employee.age)")
                        .foregroundStyle(.gray)
                }
            }
            .swipeActions {
                Button(role: .destructive) {
                    deleteEmployee()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                
                Button {
                    isEditing.toggle()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
            .fullScreenCover(isPresented: $isEditing, onDismiss: {
                employee.objectWillChange.send()  // Force UI update after dismissing edit
            }) {
                AddEmployeeView(employee: employee)
            }
        }
        .onAppear {
            loadProfileImage()
        }
        .onChange(of: employee.profileImage) { _ in
            loadProfileImage()  // Update when profile image changes
        }
    }
    
    private func loadProfileImage() {
        if let profileImageData = employee.profileImage {
            profileImage = UIImage(data: profileImageData)
        }
    }
    
    private func deleteEmployee() {
        do {
            viewContext.delete(employee)
            try viewContext.save()
        } catch {
            print("Error deleting employee: \(error.localizedDescription)")
        }
    }
}
