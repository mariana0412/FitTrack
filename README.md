# 🏃‍♀️ FitTrack

FitTrack is an iOS app designed to help users monitor and track their body metrics. 
The app allows users to log and visualize their progress over time with various body measurements like weight, waist, biceps, and more. 
It also includes a library of exercises categorized by muscle groups, complete with tags, images, and descriptions. In addition, the app provides a set of calculators for Body Mass Index (BMI), Fat Percentage, and Daily Calorie Requirements.


## Technologies Used
- UIKit: For the user interface
- Core Animation: Utilized CALayer for creating and animating progress charts to visualize user metrics dynamically
- Firebase: For user authentication, including registration, login, and password reset features
- Firestore: To store and manage user data securely in the cloud
- CocoaPods: Dependency manager used to integrate and manage third-party libraries and frameworks, including Firebase

## Architecture
- FitTrack is implemented using Model-View-ViewModel (MVVM) architecture pattern
- Coordinator pattern is used for managing navigation and flow within the app

## Features

- 🔐 User Authentication: Secure access with user registration, login, and password reset functionalities using Firebase Authentication
<table>
  <tr>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394744/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_19.48.30-portrait_pyyki1.png" alt="Signup Screen" width="200"></td>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394744/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_19.48.36-portrait_ng1ymr.png" alt="Login Screen" width="200"/></td>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394744/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_19.48.41-portrait_irdavl.png" alt="Forgot Password Screen" width="200"/></td>
  </tr>
</table>

- 👤 Profile Management: Allows users to update personal information and track body measurements with intuitive profile editing
<table>
  <tr>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394744/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_20.00.27-portrait_ql5nbi.png" alt="Profile Screen" width="200"></td>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394745/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_20.00.55-portrait_rishop.png" alt="Select Options Screen" width="200"/></td>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394974/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_23.21.18-portrait_mah82s.png" alt="Home Screen" width="200"/></td>
  </tr>
</table>

- 📊 Data Visualization: Animated progress charts to dynamically display and track user metrics over time
<table>
  <tr>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394745/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_20.01.20-portrait_uaxjmj.png" alt="Weight Chart Screen" width="200"></td>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394745/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_20.01.31-portrait_eb0xxm.png" alt="Neck Chart Screen" width="200"/></td>
  </tr>
</table>

- 🧮 Calculators: Includes calculators for Body Mass Index (BMI), Fat Percentage, and Daily Calorie Requirements to support user health monitoring
<table>
  <tr>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394748/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_20.02.19-portrait_qtzpuu.png" alt="BMI Calculator Screen" width="200"></td>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394746/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_20.02.59-portrait_vkkl4p.png" alt="Fat Percentage Calculator Screen" width="200"/></td>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394747/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_22.35.50-portrait_myjhcu.png" alt="Daily Calorie Requirement Calculator Screen" width="200"/></td>
  </tr>
</table>

- 💪 Exercises: Offers a collection of exercises categorized by muscle groups, complete with tags, images, and descriptions for effective workouts
<table>
  <tr>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394747/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_23.15.43-portrait_d3lhuh.png" alt="Choose Exercises Screen" width="200"></td>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394747/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_23.16.03-portrait_p7izr2.png" alt="Exercise Screen" width="200"/></td>
  </tr>
</table>

- ✅ User Input Validation: Error messages and disabled buttons for incorrect or incomplete input to ensure accurate data entry
<table>
  <tr>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394744/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_19.50.37-portrait_n6bzqx.png" alt="Error Signup Screen" width="200"></td>
    <td><img src="https://res.cloudinary.com/df9uihxz1/image/upload/v1725394745/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2024-09-03_at_20.02.11-portrait_hj7fn0.png" alt="Error BMI Calculator Screen" width="200"/></td>
  </tr>
</table>

- 🖱️ Custom UI Elements: Over 10 custom UI elements including buttons, alerts, switches, and segmented controls to enhance user interaction
  
- 🗂️ Tab Bar Navigation: Simplifies navigation across different sections of the app using an organized tab bar interface
  
## Requirements

- iOS 15.0 or later
- Xcode 15.0 or later

## Installation

To install RecipeFinder on your iOS device, follow these steps:

1. Clone the repository to your local machine using the command: 
    git clone https://github.com/mariana0412/FitTrack.git
2. Open the project in Xcode.
    cd FitTrack
    open FitTrack.xcworkspace
3. Install CocoaPods dependencies:
    pod install

4. Connect your iOS device to your computer and select it as the build destination in XCode
5. Build and run the application on your device by clicking the Run button or pressing Command + R. Ensure that your iOS device is running a compatible version of iOS.
