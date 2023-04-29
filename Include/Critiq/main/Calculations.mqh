// Calculates LotSize based on balance, risk and StopLoss           
double CalculateLotSize(double calc_risk, double slPrice) {
   double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   double maxLot =  SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   double tickVal = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double lotSize = accountBalance * calc_risk / 100 / (slPrice / _Point * tickVal);
   return MathMin(maxLot, MathMax(minLot,NormalizeDouble(lotSize / lotStep, 0) * lotStep));
}

double GetSLprice(double priceDelta, int orderType) {
   double price = .0;

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) - priceDelta;
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) + priceDelta;
         break;
     }
   return price;
}

double GetTPprice(double priceDelta, int orderType, double ratio) {
   double price = .0;
   priceDelta = priceDelta * ratio;

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) + priceDelta;
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) - priceDelta;
         break;
     }
   return price;
}

