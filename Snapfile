# Uncomment the lines below you want to change by removing the # in the beginning

# A list of devices you want to take the screenshots from
devices([
  "iPhone 6 - iOS 9.3",
  "iPhone 6 Plus",
  "iPad Pro (12.9 inch)"
#   "iPhone 5",
#   "iPad Pro (12.9 inch)",
#   "iPad Pro (9.7 inch)",
#   "Apple TV 1080p"
])

languages([
#  "en-US",
  "ru-RU",
#  "de-DE",
#  "it-IT",
#  ["pt", "pt_BR"] # Portuguese with Brazilian locale
])

# The name of the scheme which contains the UI Tests
scheme "CalmMoneySnapshots"

# Where should the resulting screenshots be stored?
output_directory "./screenshots"

clear_previous_screenshots true # remove the '#' to clear all previously generated screenshots before creating new ones

# Choose which project/workspace to use
# project "./CalmMoney.xcodeproj"
workspace "./CalmMoney.xcworkspace"

# Arguments to pass to the app on launch. See https://github.com/fastlane/snapshot#launch-arguments
# launch_arguments(["-favColor red"])

# For more information about all available options run
# snapshot --help

stop_after_first_error "true"
number_of_retries 0
reinstall_app "true"
erase_simulator "true"
