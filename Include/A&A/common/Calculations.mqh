// TODO: change input parameters to struct

double CalcLotSize(double calc_risk, double slPips) {
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot =  SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double tickVal = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double lotSize = accountBalance * calc_risk / 100 / (slPips / _Point * tickVal);
   return MathMin(maxLot, MathMax(minLot, NormalizeDouble(lotSize / lotStep, 0) * lotStep));
}

double CalcSL(double priceDelta, int orderType) {
   double price = .0;

   switch(orderType) {
      case ORDER_TYPE_BUY:
         price = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK) - priceDelta, _Digits);
         break;
      case ORDER_TYPE_SELL:
         price = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID) + priceDelta, _Digits);
         break;
   }
   return price;
}

double CalcTP(double priceDelta, int orderType, double ratio) {
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

double UsedPrice(int orderType) {
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

// Return final risk value (%)
double CalcPosRisk(double reduction, double rpp) {
    
    // Recalculate for all risk reducers
    double percent = CalcLossReducedRisk(reduction, rpp);

    return percent;
}


// Return reduced risk if applicable
double CalcLossReducedRisk(double reduction, double cRpp) {
    if (reduction == 0) return cRpp; 

    HistorySelect(0, TimeCurrent());
        uint total = HistoryDealsTotal();
        ulong ticket = 0;
        double profit;
        double reducedRisk = cRpp;

        for (uint i=total; i>0; i--) {
            if ((ticket = HistoryDealGetTicket(i)) > 0) {
                profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);
                if (profit < 0) reducedRisk -= reducedRisk * reduction;
                else if (profit == .0) continue;
                else break;
            }
        }
    return NormalizeDouble(reducedRisk, 4);
}