# Stockity

A Flutter project, aimed to help investors keep track of the stocks that they have invest in, their portfolios and 
also their historic transactions.

## API's 
The app used the [Yahoo API](https://rapidapi.com/apidojo/api/yh-finance/) and [Twelve API](https://rapidapi.com/twelvedata/api/twelve-data1/)
in order to gather the stock prices. It also uses firebase for logging in and signing up
and for storing the users data.

## User Interface 
In the following section i will go over the UI of the app and explain a bit about it 

<ul>
<li><h3> Login/Sign up </h3>

<img  src="C:\Users/nickd/dev/Stock_Helper/ui_images/login.jpg">
This is the login page, the sign up page is similar if you click the button signup instead.
The app has a feature that allows auto-login, this means that once you log in you dont have to login 
again, until you click logout. The security for this feature is not ideal though but since 
the app was never meant for commercial use its okay.</li>

<li><h3> Portfoclio </h3>

<img  src="C:\Users/nickd/dev/Stock_Helper/ui_images/portfolios.jpg">
<img  src="C:\Users/nickd/dev/Stock_Helper/ui_images/adding_portfolios.jpg">
This is the main portfolio screen. Here you can see all the porfolios you have open, a percentage
of the how the stock value have changed (green for positive, red for negative) and also 
your total revenue or lost for the specific portfolio. By clicking the add button you can create
new portfolios. All is needed to create a new portfolio is to choose a portfolio name. Also
by clicking the 3 dots on the right of the portfolio you have the option to either delete it 
or change its name</li>

<li><h3> Stocks</h3>
<img  src="C:\Users/nickd/dev/Stock_Helper/ui_images/empty_stocks.jpg">
<img  src="C:\Users/nickd/dev/Stock_Helper/ui_images/stocks.jpg">
At first when you create a portfolio and you click it to go inside you see the first image 
were it guides you on how to create a stock. After you start adding some stocks you see the second image
were you see the percentage change of when you bought the stock and the value it holds now if you close it.
By sliding left the stock you reveal the options to buy more of it close it or just remove it. The difference with closing it
or removing it is that if you close it it will be added into the historic data and if you remove it will not.</li>

<li><h3> Historic Data</h3>
<img  src="C:\Users/nickd/dev/Stock_Helper/ui_images/historic_transactions.jpg">
In this screen you can see your historic transactions. It shows the last 10 portfolios transactions, the stocks that you closed 
and the money you gain from the specific portfolio. At the bottom you can see the total revenue/lost you have
while using the app.


</li>
</ul>

##Notes
- You will need to add your API keys in the api_request.dart file.
- You will need to change all the URL's used for firebase with your own. Especially on auth.dart _authenticate() (line 36) you will
need your URL for authentication in order to generate the authToken







