#include <Critiq/common/Logger.mqh> 


bool ModifyOrderSL(ulong oticket, double breakeven_price) {

   MqlTradeRequest request = {};
   MqlTradeResult result = {};

   ZeroMemory(request);
   ZeroMemory(result);

   request.action = TRADE_ACTION_SLTP;
   request.position = oticket;
   request.symbol = _Symbol; // Might be useless
   request.sl = breakeven_price;

   if(!OrderSend(request, result)) {
      // gLog.Fatal("-Breakeven modify failed-");
      Print("ModifyOrderSL | OrderSend failed: ", GetLastError());
      return false;
   }
   return true;
}

bool CheckForBreakEven(double breakeven) {
   double Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   if (PositionSelect((_Symbol))) {
      ulong oticket = PositionGetTicket(0);
      double oop = PositionGetDouble(POSITION_PRICE_OPEN);
      double osl = PositionGetDouble(POSITION_SL);
      double otp = PositionGetDouble(POSITION_TP);
      ulong otype = PositionGetInteger(POSITION_TYPE);

      //--- Skip if the Open Order has stopLossPrice = openPrice or stopLoss in range openPrice +- 10 points
      if (oop == osl || (oop + (10 * Point()) > osl && oop - (10 * Point()) < osl)) {
         return false;
      } else {
         double high = iHigh(_Symbol, PERIOD_CURRENT,1);   
         double low = iLow(_Symbol, PERIOD_CURRENT,1);
         double breakEvenPrice;
         bool orderModify;
         
         if (otype == POSITION_TYPE_BUY) {
            breakEvenPrice = NormalizeDouble(((otp - oop) * breakeven + oop), Digits());
            if (Bid >= breakEvenPrice || high >= breakEvenPrice) {
               orderModify = ModifyOrderSL(oticket, oop);
               Print("CheckForBreakEven | OrderModify: ", " Open: ", oop, " SL: ", osl, " TP: ", otp, " BE: ", breakEvenPrice, " Bid: ", Bid, " High: ", high);
               return true;
            }
         } else {
            breakEvenPrice = NormalizeDouble((oop - (oop - otp) * breakeven), Digits());
            if (Ask <= breakEvenPrice || low <= breakEvenPrice) {
               orderModify = ModifyOrderSL(oticket, oop);
               Print("CheckForBreakEven | OrderModify: ", " Open: ", oop, " SL: ", osl, " TP: ", otp, " BE: ", breakEvenPrice, " Ask: ", Ask, " Low: ", low);
               
               return true;
            }
         }      
      }
   } else  Print("CheckForBreakEven | OrderSelect(0) == false", GetLastError());
   return false;
}