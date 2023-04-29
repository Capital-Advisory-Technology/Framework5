// Calculates LotSize based on balance, risk and StopLoss           
double CalculateLotSize(double risk, int points) {
   double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   double maxLot =  SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   double tickVal = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double lotSize = accountBalance * risk / 100 / (points * tickVal);
   return MathMin(maxLot, MathMax(minLot,NormalizeDouble(lotSize / lotStep, 0) * lotStep));
}

double GetSLprice(int points, int orderType) {
   double price = .0;

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) - points * Point();
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) + points * Point();
         break;
     }
   return price;
}

double GetTPprice(int points, int orderType, double posRatio) {
   double price = .0;
   points = int(points * posRatio);

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) + points * Point();
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) - points * Point();
         break;
     }
   return price;
}

