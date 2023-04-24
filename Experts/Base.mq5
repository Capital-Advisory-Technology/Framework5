//+------------------------------------------------------------------+
//|                                                         Base.mq5 |
//|                                                           Critiq |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Critiq"
#property link      ""
#property version   "1.00"

#include <Critiq-Include/backend/Risk.mqh>

int tickCount;
int tradeCount;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
    tickCount = 0;
    tradeCount = 0;
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
    Print("Total ticks: ", tickCount);
    Print("Total trades: ", tradeCount);
    
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    switch (tickCount)
    {
    case 0:
      Print("Tick", tickCount);
      Buy();
      break;
    case 3:
      Print("Tick", tickCount);
      ModifyOrderSL(0, SymbolInfoDouble(Symbol(),SYMBOL_BID) - 0.01);
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


void Buy() 
  { 
//--- prepare a request 
      MqlTradeRequest request={};
   MqlTradeResult  result={};
//--- parameters of request
   request.action   =TRADE_ACTION_DEAL;                     // type of trade operation
   request.symbol   =Symbol();                              // symbol
   request.volume   =0.1;                                   // volume of 0.1 lot
   request.type     =ORDER_TYPE_BUY;                        // order type
   request.price    =SymbolInfoDouble(Symbol(),SYMBOL_ASK); // price for opening
   request.deviation=5;                                     // allowed deviation from the price
  //  request.magic    =EXPERT_MAGIC;                          // MagicNumber of the order
//--- send the request
   if(!OrderSend(request,result))
      PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
//--- information about the operation
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
  } 


void Modify() 
  { 
//--- prepare a request 
  MqlTradeRequest request={};
  MqlTradeResult  result={};
//--- parameters of request
   request.action   =TRADE_ACTION_DEAL;                     // type of trade operation
   request.symbol   =Symbol();                              // symbol
   request.volume   =0.1;                                   // volume of 0.1 lot
   request.type     =ORDER_TYPE_BUY;                        // order type
   request.price    =SymbolInfoDouble(Symbol(),SYMBOL_ASK); // price for opening
   request.deviation=5;                                     // allowed deviation from the price
  //  request.magic    =EXPERT_MAGIC;                          // MagicNumber of the order
//--- send the request
   if(!OrderSend(request,result))
     PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
//--- information about the operation
    PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
  } 