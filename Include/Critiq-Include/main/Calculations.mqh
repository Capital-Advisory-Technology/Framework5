// #define ATRIndicator "Indicators\\Adaptive_ATR.ex4"
// #resource "\\" + ATRIndicator

// Calculates LotSize based on balance, risk and StopLoss           
double CalculateLotSize(double risk, int posPoints) {
   double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   double maxLot =  SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   double tickVal = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double lotSize = accountBalance * risk / 100 / (posPoints * tickVal);
   return MathMin(maxLot, MathMax(minLot,NormalizeDouble(lotSize / lotStep, 0) * lotStep));
}

// Calculates StopLoss based on ATR or fixed value
int CalculatePoints_ATR(double posRatio, int ATRPeriod) {
  int points;

  double atr = iATR(NULL, 0, ATRPeriod);
  points = (int)(atr * posRatio);
  
  Print(points);

  return points;
}

// int CalculateTP_posRatio(double takeProfitRatio, int posPoints ) {
//   return int((posPoints * takeProfitRatio));
// }

double GetSLprice(int posPoints, int orderType) {
   double price = .0;

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) - posPoints * Point();
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) + posPoints * Point();
         break;
     }
   return price;
}

double GetTPprice(int posPoints, int orderType, double posRatio) {
   double price = .0;
   posPoints = int(posPoints * posRatio);

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) + posPoints * Point();
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) - posPoints * Point();
         break;
     }
   return price;
}
//+------------------------------------------------------------------+
