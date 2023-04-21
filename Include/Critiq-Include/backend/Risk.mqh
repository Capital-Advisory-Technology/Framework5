#include <Critiq-Include/common/Logger.mqh> 
#include <Trade/SymbolInfo.mqh>

// Left to replace OrderModify() functions, will be done by MqlTradeRequest{}
// MQL5 Reference  /  Constants, Enumerations and Structures  /  Trade Constants / Trade Operation Types 

bool CheckForBreakEven(double breakeven) {
   double Ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   double Bid = SymbolInfoDouble(Symbol(), SYMBOL_ASK);

   if (OrderSelect(0) == true) {
      int oticket = OrderGetTicket(0);
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
               orderModify = PositionModify(oticket, oop, otp);
               return true;
            } else return false;
         } else {
            breakEvenPrice = NormalizeDouble((oop - (oop - otp) * breakeven), Digits());
            if (SymbolInfoDouble(Symbol(), SYMBOL_ASK) <= breakEvenPrice || low <= breakEvenPrice) {
               orderModify = OrderModify(oticket, oop, oop, otp, 0, clrOrange);
               return true;
            } else return false;
         }      
      }
   } else return false;
}