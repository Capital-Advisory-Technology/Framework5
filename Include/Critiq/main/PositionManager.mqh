#include <Trade/Trade.mqh>

#include <Critiq/main/Risk.mqh>
#include <Critiq/main/Calculations.mqh>
#include <Critiq/common/Structures.mqh>

class PositionManager {
    protected:  
        CTrade  *trade;
        
    public:
        PositionManager(void);
        ~PositionManager(void);

        void OrderOpen(PositionParams &params);
                       
        void OrderClose();
        void OrderModify(double sl, double tp);
        void OrderPartialClose(double volume);   

        bool isOrderOpen() { return PositionsTotal() != 0;};
};

extern PositionManager *positionManager = new PositionManager;

PositionManager::PositionManager(void): trade(new CTrade) {}

void PositionManager::~PositionManager(void) {
    delete trade;
}

void PositionManager::OrderOpen(PositionParams &params) {
    trade.PositionOpen(_Symbol, params.type, params.volume, params.openPrice, params.slPrice, params.tpPrice, "");
}

void PositionManager::OrderModify(double sl, double tp) {
    ulong oticket = PositionGetTicket(0);  
    trade.PositionModify(_Symbol, sl, tp);
}

void PositionManager::OrderClose() {    
    ulong oticket = PositionGetTicket(0);  
    trade.PositionClose(oticket, ULONG_MAX);     
}

void PositionManager::OrderPartialClose(double cVolume) {
    ulong oticket = PositionGetTicket(0);  
    trade.PositionClosePartial(_Symbol, cVolume);     
}
