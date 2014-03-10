Who's Who
=========

Universal (iPhone + iPad) Who's Who iOS App

Xcode version: 5.0.2
Compatible iOS Version:  6.0 +
Orientation: support all orientation

Used external source list:
1. Happle for HTML parsing
2. Apple Reachability class for Internet connection check

Work flow:
1. Hide Status bar
2. Used Nib file view representation
3. Custom Cell for Employee detail representation
4. Used NSAutoLayout for view orientation support
5. Download employee list from given url background thread
6. Parse downloaded html content using Happle xml query method
7. Used NSURLConnection to download employee profile image asynchronously
8. Refresh button action will download employee list again from server
9. Check internet connection availability using apple Reachability Class
10. If no internet connection available then user can load local data.
11. To save data locally used encode/decode
12. When apps come to foreground it will check internet connection and prompt user to choose local data loading
13. Helper file to save and retrieve employee data locally
14. Employee data will saved when app goes to background mode and if online mode


Not Done Yet:
1. Unit Testing

