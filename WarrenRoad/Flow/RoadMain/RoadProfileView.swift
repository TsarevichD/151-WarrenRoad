//
//  RoadProfileView.swift


import SwiftUI
import AVFoundation
import Photos

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            picker.modalPresentationStyle = .formSheet
            picker.preferredContentSize = CGSize(width: 600, height: 600)
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ProfilePhotoView: View {
    let selectedImage: UIImage?
    let onTapAction: () -> Void
    
    var body: some View {
        Button(action: onTapAction) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.orange, lineWidth: 3)
                    )
            }
        }
    }
}

struct CustomTextFieldPad: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let onDone: () -> Void
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        textField.textColor = .black
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        doneButton.tintColor = .systemBlue
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneButton
        ]
        textField.inputAccessoryView = toolbar
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, onDone: onDone)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        let onDone: () -> Void
        
        init(text: Binding<String>, onDone: @escaping () -> Void) {
            self._text = text
            self.onDone = onDone
        }
        
        @objc func doneButtonTapped() {
            onDone()
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isValid = allowedCharacters.isSuperset(of: characterSet)
            
            if isValid {
                if let text = textField.text,
                   let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange, with: string)
                    if updatedText.count <= 2 {
                        self.text = updatedText
                    }
                }
            }
            return false
        }
    }
}

struct RoadProfileView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingSourceTypeAlert = false
    @State private var isNameEditing = false
    @State private var isAgeEditing = false
    @State private var tempName = ""
    @State private var tempAge = ""
    @State private var isAnyFieldEditing = false
    @State private var selectedVehicleType: String = "Office Manager"
    @FocusState private var isNameFieldFocused: Bool
    @FocusState private var isAgeFieldFocused: Bool
    @State private var showingPermissionAlert = false
    @State private var permissionAlertMessage = ""
    @State private var showingDeleteAccountAlert = false
    @State private var hasChanges = false
    @State private var originalName: String = ""
    @State private var originalAge: String = ""
    @State private var originalVehicleType: String = "Office Manager"
    @State private var originalImage: UIImage?
    @EnvironmentObject var router: WarrenRouterView
    
    private let colors = (
        darkBrown: Color.darkBrown,
        lightYellow: Color.lightYellow,
        oliveBrown: Color.oliveBrown,
        green: Color.green,
        warmBrown: Color.warmBrown,
        lightOlive: Color.lightOlive,
        goldenBeige: Color.goldenBeige
    )

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    backgroundGradient
                    floatingElements(geometry: geometry)
                    profileContent
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    homeButton
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .actionSheet(isPresented: $showingSourceTypeAlert) {
            ActionSheet(
                title: Text("Select source"),
                buttons: [
                    .default(Text("Camera")) {
                        print("Camera option selected")
                        checkCameraPermission()
                    },
                    .default(Text("Gallery")) {
                        print("Gallery option selected")
                        checkPhotoLibraryPermission()
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
                .onDisappear {
                    if let image = selectedImage {
                        saveImageToLocal(image: image)
                        checkForChanges()
                    }
                }
        }
        .alert("Permission Required", isPresented: $showingPermissionAlert) {
            Button("Settings", role: .none) {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(permissionAlertMessage)
        }
        .alert("Clear All Data", isPresented: $showingDeleteAccountAlert) {
            Button("Yes", role: .destructive) {
                clearAllData()
            }
            Button("No", role: .cancel) {}
        } message: {
            Text("All your office furniture and equipment storage will be deleted. Are you sure you want to clear all data?")
        }
        .onAppear {
            initializeOriginalValues()
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colors.darkBrown,
                colors.oliveBrown,
                colors.warmBrown,
                colors.darkBrown.opacity(0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private func floatingElements(geometry: GeometryProxy) -> some View {
        VStack {
            HStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                colors.goldenBeige.opacity(0.9),
                                colors.green.opacity(0.7)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                    .offset(x: -geometry.size.width/2 + 80, y: -geometry.size.height/2 + 100)
                
                Spacer()
            }
        }
    }
    
    private var profileContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AdaptiveSize.spacing(25)) {
                headerSection
                ProfilePhotoView(
                    selectedImage: selectedImage ?? getImageFromLocal(),
                    onTapAction: {
                        showingSourceTypeAlert = true
                    }
                )
                nameSection
                workPositionSection
                actionButtons
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AdaptiveSize.spacing(15)) {
            Text("Warren Road Profile")
                .adaptiveFont(.largeTitle, size: 32)
                .fontWeight(.bold)
                .foregroundColor(colors.lightYellow)
                .shadow(color: colors.darkBrown.opacity(0.5), radius: 3, x: 0, y: 2)
            
            Text("Manage Your Office Storage Profile")
                .adaptiveFont(.title3, size: 16)
                .fontWeight(.medium)
                .foregroundColor(colors.lightYellow.opacity(0.9))
                .shadow(color: colors.darkBrown.opacity(0.3), radius: 1, x: 0, y: 1)
        }
        .adaptivePadding(.top, 12)
    }
    
    // MARK: - Name Section
    private var nameSection: some View {
        VStack(spacing: AdaptiveSize.spacing(12)) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .foregroundColor(colors.lightYellow)
                
                Text("Worker Name")
                    .adaptiveFont(.title2, size: 20)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightYellow)
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 20)
            
            nameInputField
        }
        .adaptivePadding(.horizontal, 20)
    }
    
    // MARK: - Name Input Field
    private var nameInputField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.lightYellow.opacity(0.95),
                            colors.goldenBeige.opacity(0.9)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: AdaptiveSize.buttonHeight(60))
            
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.goldenBeige.opacity(0.6),
                            colors.green.opacity(0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(height: AdaptiveSize.buttonHeight(60))
            
            HStack(spacing: AdaptiveSize.spacing(15)) {
                if isNameEditing {
                    TextField("Enter your name", text: $tempName)
                        .adaptiveFont(.body, size: 18)
                        .fontWeight(.semibold)
                        .foregroundColor(colors.darkBrown)
                        .adaptivePadding(.leading, 20)
                        .focused($isNameFieldFocused)
                        .onChange(of: tempName) { _ in
                            checkForChanges()
                        }
                        .onChange(of: isNameFieldFocused) { newValue in
                            if !newValue {
                                saveName()
                            }
                        }
                } else {
                    Text(getUserName())
                        .adaptiveFont(.body, size: 18)
                        .fontWeight(.semibold)
                        .foregroundColor(colors.darkBrown)
                        .adaptivePadding(.leading, 20)
                }
                
                Spacer()
                
                Button(action: {
                    if !isAnyFieldEditing {
                        isNameEditing = true
                        isAnyFieldEditing = true
                        tempName = getUserName()
                        isNameFieldFocused = true
                        checkForChanges()
                    }
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: AdaptiveSize.iconSize(24)))
                        .foregroundColor(colors.goldenBeige)
                }
                .adaptivePadding(.trailing, 20)
            }
        }
        .shadow(color: colors.goldenBeige.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Work Position Section
    private var workPositionSection: some View {
        VStack(spacing: AdaptiveSize.spacing(15)) {
            HStack {
                Image(systemName: "briefcase.circle.fill")
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .foregroundColor(colors.lightYellow)
                
                Text("Work Position")
                    .adaptiveFont(.title2, size: 20)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightYellow)
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 20)
            
            workPositionField
        }
        .adaptivePadding(.horizontal, 20)
    }
    
    // MARK: - Work Position Field
    private var workPositionField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.lightYellow.opacity(0.95),
                            colors.goldenBeige.opacity(0.9)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: AdaptiveSize.buttonHeight(60))
            
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.green.opacity(0.6),
                            colors.goldenBeige.opacity(0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(height: AdaptiveSize.buttonHeight(60))
            
            HStack(spacing: AdaptiveSize.spacing(15)) {
                Text(selectedVehicleType)
                    .adaptiveFont(.body, size: 18)
                    .fontWeight(.semibold)
                    .foregroundColor(colors.darkBrown)
                    .adaptivePadding(.leading, 20)
                
                Spacer()
                
                Menu {
                    ForEach(["Office Manager", "Administrative Assistant", "IT Specialist", "HR Coordinator", "Finance Analyst", "Operations Manager", "Project Coordinator", "Executive Assistant"], id: \.self) { vehicleType in
                        Button(vehicleType) {
                            selectedVehicleType = vehicleType
                            saveVehicleType()
                            checkForChanges()
                        }
                    }
                } label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.system(size: AdaptiveSize.iconSize(24)))
                        .foregroundColor(colors.green)
                }
                .adaptivePadding(.trailing, 20)
            }
        }
        .shadow(color: colors.green.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: AdaptiveSize.spacing(15)) {
            saveButton
            clearDataButton
        }
        .adaptivePadding(.bottom, 50)
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: {
            saveAccountChanges()
        }) {
            HStack(spacing: AdaptiveSize.spacing(12)) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: AdaptiveSize.iconSize(18)))
                    .foregroundColor(colors.lightYellow)
                
                Text("Save Profile")
                    .adaptiveFont(.headline, size: 18)
                    .fontWeight(.semibold)
                    .foregroundColor(colors.lightYellow)
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 20)
            .frame(height: AdaptiveSize.buttonHeight(50))
            .background(
                LinearGradient(
                    colors: hasChanges ? [
                        colors.green,
                        colors.green.opacity(0.8)
                    ] : [
                        colors.oliveBrown,
                        colors.oliveBrown.opacity(0.8)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .adaptiveCornerRadius(25)
            .shadow(
                color: hasChanges ? colors.green.opacity(0.3) : colors.oliveBrown.opacity(0.3),
                radius: hasChanges ? 6 : 3,
                x: 0,
                y: hasChanges ? 3 : 1
            )
        }
        .disabled(!hasChanges)
        .opacity(hasChanges ? 1.0 : 0.6)
        .adaptivePadding(.horizontal, 24)
    }
    
    // MARK: - Clear Data Button
    private var clearDataButton: some View {
        Button(action: {
            showingDeleteAccountAlert = true
        }) {
            HStack(spacing: AdaptiveSize.spacing(12)) {
                Image(systemName: "trash.circle.fill")
                    .font(.system(size: AdaptiveSize.iconSize(18)))
                    .foregroundColor(colors.lightYellow)
                
                Text("Clear All Data")
                    .adaptiveFont(.headline, size: 18)
                    .fontWeight(.semibold)
                    .foregroundColor(colors.lightYellow)
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 20)
            .frame(height: AdaptiveSize.buttonHeight(50))
            .background(
                LinearGradient(
                    colors: [
                        colors.oliveBrown.opacity(0.8),
                        colors.darkBrown.opacity(0.6)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .adaptiveCornerRadius(25)
            .shadow(color: colors.darkBrown.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        .adaptivePadding(.horizontal, 24)
    }
    
    // MARK: - Home Button
    private var homeButton: some View {
        Button(action: {
            router.currentScreen = .home
        }) {
            HStack(spacing: 8) {
                Image(systemName: "house.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text("Home")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(colors.lightYellow)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colors.goldenBeige.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colors.goldenBeige.opacity(0.6), lineWidth: 1)
                    )
            )
        }
    }
    
    
    private func getUserName() -> String {
        return UserDefaults.standard.string(forKey: "workerName") ?? "Worker"
    }
    
    private func getUserAge() -> String {
        return UserDefaults.standard.string(forKey: "collectorAge") ?? "0"
    }
    
    private func getVehicleType() -> String {
        return UserDefaults.standard.string(forKey: "workPosition") ?? "Office Manager"
    }
    
    private func saveName() {
        UserDefaults.standard.set(tempName, forKey: "workerName")
        isNameEditing = false
        isAnyFieldEditing = false
        checkForChanges()
    }
    
    private func saveAge() {
        UserDefaults.standard.set(tempAge, forKey: "collectorAge")
        isAgeEditing = false
        isAnyFieldEditing = false
        isAgeFieldFocused = false
        checkForChanges()
    }
    
    private func saveVehicleType() {
        UserDefaults.standard.set(selectedVehicleType, forKey: "workPosition")
        checkForChanges()
    }
    
    private func initializeOriginalValues() {
        originalName = getUserName()
        originalAge = getUserAge()
        originalVehicleType = getVehicleType()
        originalImage = getImageFromLocal()
        selectedVehicleType = getVehicleType()
        hasChanges = false
    }
    
    private func checkForChanges() {
        let currentName = isNameEditing ? tempName : getUserName()
        let currentAge = isAgeEditing ? tempAge : getUserAge()
        let currentVehicleType = selectedVehicleType
        let currentImage = getImageFromLocal()
        
        hasChanges = (currentName != originalName) ||
                    (currentAge != originalAge) ||
                    (currentVehicleType != originalVehicleType) ||
                    (currentImage != originalImage)
    }
    
    private func saveAccountChanges() {
        if isNameEditing {
            saveName()
        }
        if isAgeEditing {
            saveAge()
        }
        saveVehicleType()
        
        originalName = getUserName()
        originalAge = getUserAge()
        originalVehicleType = getVehicleType()
        originalImage = getImageFromLocal()
        
        isNameEditing = false
        isAgeEditing = false
        isAnyFieldEditing = false
        isNameFieldFocused = false
        isAgeFieldFocused = false
        
        hasChanges = false
    }
    
    private func clearAllData() {
        for storage in memory.furnitureStorage {
            memory.deleteFurnitureStorage(storage.id)
        }
        for storage in memory.equipmentStorage {
            memory.deleteEquipmentStorage(storage.id)
        }
        
        UserDefaults.standard.removeObject(forKey: "workerName")
        UserDefaults.standard.removeObject(forKey: "collectorAge")
        UserDefaults.standard.removeObject(forKey: "workPosition")
        
        let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
        try? FileManager.default.removeItem(at: filename)
        
        selectedImage = nil
        tempName = ""
        tempAge = ""
        selectedVehicleType = "Office Manager"
        hasChanges = false
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func saveImageToLocal(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
            try? data.write(to: filename)
        }
    }
    
    private func getImageFromLocal() -> UIImage? {
        let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
        if let data = try? Data(contentsOf: filename) {
            return UIImage(data: data)
        }
        return nil
    }
    
    private func checkCameraPermission() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            permissionAlertMessage = "Camera is not available on this device. Please use photo library instead."
            showingPermissionAlert = true
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            sourceType = .camera
            showingImagePicker = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        sourceType = .camera
                        showingImagePicker = true
                    } else {
                        permissionAlertMessage = "Camera access is required to take profile pictures."
                        showingPermissionAlert = true
                    }
                }
            }
        case .denied, .restricted:
            permissionAlertMessage = "Please enable camera access in Settings to take profile pictures."
            showingPermissionAlert = true
        @unknown default:
            permissionAlertMessage = "Camera access is not available."
            showingPermissionAlert = true
        }
    }
    
    private func checkPhotoLibraryPermission() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            permissionAlertMessage = "Photo library is not available on this device."
            showingPermissionAlert = true
            return
        }
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            sourceType = .photoLibrary
            showingImagePicker = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        sourceType = .photoLibrary
                        showingImagePicker = true
                    } else {
                        permissionAlertMessage = "Photo library access is required to select profile pictures."
                        showingPermissionAlert = true
                    }
                }
            }
        case .denied, .restricted:
            permissionAlertMessage = "Please enable photo library access in Settings to select profile pictures."
            showingPermissionAlert = true
        @unknown default:
            permissionAlertMessage = "Photo library access is not available."
            showingPermissionAlert = true
        }
    }
}

#Preview {
    RoadProfileView()
}

