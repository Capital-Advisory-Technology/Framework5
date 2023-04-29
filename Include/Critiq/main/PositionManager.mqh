#include <Trade/Trade.mqh>

#include <Critiq/main/Risk.mqh>
#include <Critiq/main/Calculations.mqh>


class PositionManager {
    protected:  
        CTrade  *trade;
        
    public:
        PositionManager(void);
        ~PositionManager(void);

        // Order Management
        void OrderOpen(ENUM_ORDER_TYPE orderType, double volume,
                       double slPrice, double tpPrice);
                       
        void OrderClose();
        void OrderModify(double sl, double tp);
        void OrderPartialClose(double volume);   

        // Order func.
        bool isOrderOpen() { return PositionsTotal() != 0;};
};

extern PositionManager *positionManager = new PositionManager;

PositionManager::PositionManager(void): 
                                        trade(new CTrade) {}
void PositionManager::~PositionManager(void) {
    delete trade;
}

void PositionManager::OrderOpen(ENUM_ORDER_TYPE orderType, double cVolume,
                                double slPrice, double tpPrice) {
    Print("Opening order!!!");
    string symbol = Symbol();
    
    switch (orderType) {
    case (ORDER_TYPE_BUY):
        trade.PositionOpen(symbol, orderType, cVolume,
                            SymbolInfoDouble(symbol, SYMBOL_ASK),
                             slPrice, tpPrice, "Hello, Casino!");
        break;
    case (ORDER_TYPE_SELL):
        trade.PositionOpen(symbol, orderType, cVolume,
                            SymbolInfoDouble(symbol, SYMBOL_BID),
                            slPrice, tpPrice, "Hello, gay bear!");
        break;
    default:
        break;
    }
} 

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