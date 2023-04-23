#include <Critiq-Include/common/Logger.mqh> 

bool ModifyOrderBreakeven(ulong oticket, double breakeven_price) {
   MqlTradeRequest request = {};
   MqlTradeResult result = {};

   ZeroMemory(request);
   ZeroMemory(result);   

   request.action = TRADE_ACTION_SLTP;
   request.position = oticket;
   request.symbol = Symbol(); // Might be useless
   request.sl = breakeven_price;

   if(!OrderSend(request, result)) {
      gLog.Fatal("-Breakeven modify failed-");
      return false;
   }
     
   return true;
}

bool CheckForBreakEven(double breakeven) {
   double Ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   double Bid = SymbolInfoDouble(Symbol(), SYMBOL_ASK);

   if (OrderSelect(0) == true) {
      ulong oticket = OrderGetTicket(0);
      double oop = OrderGetDouble(ORDER_PRICE_OPEN);
      double osl = OrderGetDouble(ORDER_SL);
      double otp = OrderGetDouble(ORDER_TP);
      //--- Skip if the Open Order has stopLossPrice = openPrice or stopLoss in range openPrice +- 10 points
      if (oop == osl || (oop + (10 * Point()) > osl && oop - (10 * Point()) < osl)) {
         return false;
      } else {
         double high = iHigh(OrderGetString(ORDER_SYMBOL), PERIOD_CURRENT,1);   
         double low = iLow(OrderGetString(ORDER_SYMBOL), PERIOD_CURRENT,1);
         double breakEvenPrice;
         bool orderModify;
         
         if (ENUM_ORDER_TYPE(OrderGetInteger(ORDER_TYPE)) == ORDER_TYPE_BUY) {
            breakEvenPrice = NormalizeDouble(((otp - oop) * breakeven + oop), Digits());
            if (SymbolInfoDouble(Symbol(), SYMBOL_BID) >= breakEvenPrice || high >= breakEvenPrice) {
               orderModify = ModifyOrderBreakeven(oticket, oop);
               return true;
            } else return false;
         } else {
            breakEvenPrice = NormalizeDouble((oop - (oop - otp) * breakeven), Digits());
            if (SymbolInfoDouble(Symbol(), SYMBOL_ASK) <= breakEvenPrice || low <= breakEvenPrice) {
               orderModify = ModifyOrderBreakeven(oticket, oop);
               return true;
            } else return false;
         }      
      }
   } else return false;
}