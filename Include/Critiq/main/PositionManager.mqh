#include <Trade/Trade.mqh>

#include <Critiq/backend/RiskModel.mqh>
#include <Critiq/main/Calculations.mqh>


class PositionManager {
    protected:  
        CTrade  *trade;
        
    public:
        PositionManager(void);
        ~PositionManager(void);

        void OrderOpen(OpenTradeParams &params);
                       
        void OrderClose();
        void OrderModify(double sl, double tp);
        void OrderPartialClose(double volume);   

        bool isOrderOpen() { return PositionsTotal() != 0;};
        void checkBreakEven();
};

extern PositionManager *positionManager = new PositionManager;

PositionManager::PositionManager(void): trade(new CTrade) {}

void PositionManager::~PositionManager(void) {
    delete trade;
}

void PositionManager::OrderOpen(OpenTradeParams &params) {
    string symbol = Symbol();
    
    switch (params.type) {
    case (ORDER_TYPE_BUY):
        trade.PositionOpen(symbol, params.type, params.volume,
                            SymbolInfoDouble(symbol, SYMBOL_ASK),
                             params.slPrice, params.tpPrice, "");
        break;
    case (ORDER_TYPE_SELL):
        trade.PositionOpen(symbol, params.type, params.volume,
                            SymbolInfoDouble(symbol, SYMBOL_BID),
                            params.slPrice, params.tpPrice, "");
        break;
    default:
        break;
    }
}
// void PositionManager::OrderOpen(ENUM_ORDER_TYPE orderType, double cVolume,
//                                 double slPrice, double tpPrice) {
//     string symbol = Symbol();
    
//     switch (orderType) {
//     case (ORDER_TYPE_BUY):
//         trade.PositionOpen(symbol, orderType, cVolume,
//                             SymbolInfoDouble(symbol, SYMBOL_ASK),
//                              slPrice, tpPrice, "");
//         break;
//     case (ORDER_TYPE_SELL):
//         trade.PositionOpen(symbol, orderType, cVolume,
//                             SymbolInfoDouble(symbol, SYMBOL_BID),
//                             slPrice, tpPrice, "");
//         break;
//     default:
//         break;
//     }
// } 

void PositionManager::OrderModify(double sl, double tp) {
    ulong oticket = PositionGetTicket(0);  
    trade.PositionModify(Symbol(), sl, tp);
}

void PositionManager::OrderClose() {    
    ulong oticket = PositionGetTicket(0);  
    trade.PositionClose(oticket, ULONG_MAX);     
}

void PositionManager::OrderPartialClose(double cVolume) {
    ulong oticket = PositionGetTicket(0);  
    trade.PositionClose(oticket, 0);     
}

void PositionManager::checkBreakEven() {
    
}