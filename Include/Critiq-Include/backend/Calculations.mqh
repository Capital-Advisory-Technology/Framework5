// #define ATRIndicator "Indicators\\Adaptive_ATR.ex4"
// #resource "\\" + ATRIndicator

// Calculates LotSize based on balance, risk and StopLoss           
double CalculateLotSize(double risk, int PointsSL) {
   double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   double maxLot =  SymbolInfoDouble(Symbol(), SzYMBOL_VOLUME_MAX);
   double tickVal = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double lotSize = accountBalance * risk / 100 / (PointsSL * tickVal);
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

int CalculateTP_Ratio(double takeProfitRatio, int PointsSL ,bool fixed) {
  int takeProfit;
  if(fixed) takeProfit = (int)MathRound(takeProfitRatio);
  else {
    takeProfit = (int)(PointsSL * takeProfitRatio);
  }

  return takeProfit;
}

double GetSLprice(int PointsSL, int orderType) {
   double price = .0;

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) - PointsSL * Point();
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) + PointsSL * Point();
         break;
     }
   return price;
}

double GetTPprice(int PointsTP, int orderType) {
   double price = .0;

   switch(orderType)
     {
      case ORDER_TYPE_BUY:
         price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) + PointsTP * Point();
         break;
      case ORDER_TYPE_SELL:
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID) - PointsTP * Point();
         break;
     }
   return price;
}
//+------------------------------------------------------------------+
