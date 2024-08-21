# AD User Removal Script

## Overview
This PowerShell script is designed to remove a specified user from one or more Active Directory groups. It provides a user-friendly interface to select groups for removal and handles errors gracefully.

## Requirements
- Active Directory module for PowerShell
- Administrative privileges to modify Active Directory groups

## Usage
1. Run the script in a PowerShell environment with the Active Directory module installed.
2. Enter the login of the target user when prompted.
3. A list of groups the user is a member of will be displayed.
4. Enter the numbers of the groups to remove, separated by commas, or 'n' to cancel.
5. Confirm the removal of the user from the selected groups.

## Notes
- The script uses colored messages to distinguish between informational, warning, and error messages.
- It checks for the existence of groups and handles cases where a group is not found or is not an AD group.

## License
This script is provided under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributing
Contributions are welcome. Please open an issue or submit a pull request on GitHub.

## Download
You can download the script and the executable from the [Releases](https://github.com/yourusername/AD-User-Removal-Script/releases) page.

## Contact
For any questions or issues, please open an issue on GitHub or contact (dmitry.yab@yandex.ru).

---

Thank you for using AD User Removal Script!
