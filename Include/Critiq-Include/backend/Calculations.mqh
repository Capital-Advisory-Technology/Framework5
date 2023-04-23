#define ATRIndicator "Indicators\\Adaptive_ATR.ex4"
#resource "\\" + ATRIndicator

// Calculates LotSize based on balance, risk and StopLoss           
double GetLotSize(double risk, int stopLoss) {
   double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   double maxLot =  SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   double tickVal = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double lotSize = accountBalance * risk / 100 / (stopLoss * tickVal);
   return MathMin(maxLot, MathMax(minLot,NormalizeDouble(lotSize / lotStep, 0) * lotStep));
}

// Calculates StopLoss based on ATR or fixed value
int CalculateSL_ATR(double stopLossRatio, int ATRPeriod, bool fixed) {
  int stopLoss;
  if(fixed) stopLoss = (int)MathRound(stopLossRatio);
  else {
    double atr = iATR(Symbol(), Period(), ATRPeriod);
    stopLoss = (int)(atr / Point() * stopLossRatio);
    if (stopLoss < 100) stopLoss = 100;
  }

  return stopLoss;
}

int CalculateTP_Ratio(double takeProfitRatio, int stopLoss ,bool fixed) {
  int takeProfit;
  if(fixed) takeProfit = (int)MathRound(takeProfitRatio);
  else {
    takeProfit = (int)(stopLoss * takeProfitRatio);
  }

  return takeProfit;
}

double GetSLprice(int stopLoss, int orderType) {
   double price = .0;

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) - stopLoss * Point();
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) + stopLoss * Point();
         break;
     }
   return price;
}

double GetTPprice(int takeProfit, int orderType) {
   double price = .0;

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) + takeProfit * Point();
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) - takeProfit * Point();
         break;
     }
   return price;
}
//+------------------------------------------------------------------+
