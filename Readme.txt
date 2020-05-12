ReadMe.txt
Google Drive Link to files https://drive.google.com/open?id=1hhnf1lvut5DR0sK2RZtLyWS2vvCDJp63
Files included:
UI Walthorugh.docx - Walkthrough of View Controllers
MVC Architecture.pdf - Diagram showcasing functionality of MVC in program
LocalStocks UML Diagram.pdf - UML diagram of class' relationship and functionality
StockPage.zip - zip file of xcode project
Functionality in xcode project:
The functionality implemented is working with the API to acquire stock prices. Currently the API is alphavantage, which offers multiple options to getting stock data. Right now, I am not 100% sure on how to acquire all the correct date information, so I am still working with that, as it returns a variety of close values at various end dates, and I am not sure how many end dates are included. However, October 4th was working, so it is currently hard coded to that date. The function takes a String input, converts it to uppercase, and performs a query for the daily information. If the string includes a space, it ignores the query and sets it as Microsoft's stock. It is then read by a class variable, which is set to the dollar amount of the stock, and the output is displayed on the screen. If an error case occurs or the stock doesn't exist, the field will read error. The UI is fairly basic, and will be updated.