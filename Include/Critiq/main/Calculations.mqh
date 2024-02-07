// TODO: change input parameters to struct

double CalculateLotSize(double calc_risk, double slPips) {
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP); 
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot =  SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double tickVal = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double lotSize = accountBalance * calc_risk / 100 / (slPips / _Point * tickVal);
   return MathMin(maxLot, MathMax(minLot, NormalizeDouble(lotSize / lotStep, 0) * lotStep));
}

double GetSLprice(double priceDelta, int orderType) {
   double price = .0;
   double limitDelta = .0;

   switch(orderType) {
      case ORDER_TYPE_BUY:
         limitDelta = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK));
         price = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK) - priceDelta, _Digits);
         break;
      case ORDER_TYPE_SELL:
         price = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID) + priceDelta, _Digits);
         break;
   }
   return price;
}

double GetTPprice(double priceDelta, int orderType, double ratio) {
   double price = .0;
   priceDelta = priceDelta * ratio;

   switch(orderType) {
      case ORDER_TYPE_BUY:
         price = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK) + priceDelta, _Digits);
         break;
      case ORDER_TYPE_SELL:
         price = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID) - priceDelta, _Digits);
         break;
   }
   return price;
}

double GetOpenPrice(int orderType) {
   double price = .0;

   switch(orderType) {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         break;
   }
   return price;
}

double GetLimitPrice(int orderType) {
   double price = .0;

   switch (orderType) {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         break; 
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         break;
      case else:
         SetUserError(1);
         break;
   }

   return price;
}