#property copyright "Critiq"

#include <Critiq-Include/backend/Risk.mqh>
#include <Critiq-Include/main/PositionManager.mqh>
#include <Critiq-Include/common/Alerts.mqh>

#include <Trade\Trade.mqh>

int tickCount;
int tradeCount;
PositionManager *positionManager = new PositionManager;
Alerts *alerts = new Alerts;

int OnInit() {
    positionManager.setPosRatio(10);
    positionManager.setRisk(1);
    tickCount = 0;
    tradeCount = 0;
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
    Print("Total ticks: ", tickCount);
    delete positionManager;
}

void OnTick()
  {
    switch (tickCount)
    {
    case 5:
      Print("Tick Count: ", tickCount);
      alerts.sendMail("Casino Bet", "Buy Open");
      alerts.sendMobile("Buy open");

      break;
    case 200:
      Print("Tick Count: ", tickCount);
      alerts.sendMail("Casino Bet", "Sell Open");
      alerts.sendMobile("Sell open");
      break;
    default:
      break;
    }
   tickCount += 1;
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
    tradeCount += 1;
  }
//+------------------------------------------------------------------+


// void Buy() 
//   { 
// //--- prepare a request 
//   ResetLastError();
//       MqlTradeRequest m_request={};
//    MqlTradeResult  result={};
// //--- parameters of request
//    m_request.action   =TRADE_ACTION_PENDING;
//    m_request.symbol   =_Symbol;
//   //  m_request.magic    =m_magic;
//    m_request.volume   =0.1;
//    m_request.type     =ORDER_TYPE_BUY;
//    m_request.price    =SymbolInfoDouble(_Symbol,SYMBOL_ASK);
//    m_request.sl       =0;
//    m_request.tp       =0;
//    m_request.deviation=5;
//    //--- check order type
   
//    m_request.comment="asd";
// //--- action and return the result
//    if(!OrderSend(m_request,result))
//       PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
// //--- information about the operation
//    PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
//   } 


// void Modify() 
//   { 
// //--- prepare a request 
//   MqlTradeRequest request={};
//   MqlTradeResult  result={};
// //--- parameters of request
//    request.action   =TRADE_ACTION_SLTP;                     // type of trade operation
//    request.symbol   =Symbol();                              // symbol
//    request.volume   =0.1;                                   // volume of 0.1 lot
//    request.type     =ORDER_TYPE_BUY;                        // order type
//    request.price    =SymbolInfoDouble(Symbol(),SYMBOL_ASK); // price for opening
//    request.deviation=5;                                     // allowed deviation from the price
//   //  request.magic    =EXPERT_MAGIC;                          // MagicNumber of the order
// //--- send the request
//    if(!OrderSend(request,result))
//      PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
// //--- information about the operation
//     PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
//   } 