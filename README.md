# Kasjer - Cashier-calculator
iOS app that helps with calculating the ammount in the cashbox and helps you split the bills between cashbox and safebox.

This app was written with a purpose to simplify some repetable processes at my work at the time.
In some buisnesses it is required to count the cash in the cashbox in the beginning of the day and before closing.
At the end of the day there a cashier should put the exceeding amount of cash to the safebox and leave required ammount in the cashbox.

In Kasjer app user inputs the ammount of each nominal in the cashbox and then app calculates which nominals in what quantity to keep in the cashbox.
Of course we want only the lowest nominals to be kept in cashbox if possible because they are more usefull for the change.
Pennies are always kept in the cashbox.

If it is required to leave 500 PLN in cashbox Kasjer app will try to get as close to the number as possible but:
- it will keep in the cashbox only ammount exceding the limit
- it will try to keep the lowest nominals

## Screenshots:
List of nominals with quantity created from user input:
![Simulator Screenshot - iPhone 16 - 2025-04-01 at 23 05 47](https://github.com/user-attachments/assets/be09b329-ff7f-4afa-ab0e-cab2601dadb1)

Summary view showing how much to put to safebox and cashbox with list of nominals with quantity for each of them:
![simulator_screenshot_BCDCAA1C-5012-464D-9B09-E97E3F2EA710](https://github.com/user-attachments/assets/48b4b9c2-47d8-41f5-8cc1-0c6792d6cb36)

Settings view lets the user set new limit for the casbox (how much money needs to stay):
![simulator_screenshot_82B533DC-401F-4E06-A90F-C46D2981E225](https://github.com/user-attachments/assets/e7263856-6207-4b58-81ed-59d348bf44a8)
