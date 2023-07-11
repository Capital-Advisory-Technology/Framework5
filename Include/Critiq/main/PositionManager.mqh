#include <Trade/Trade.mqh>
#include <Critiq/common/Structures.mqh>
#include <Critiq/common/OrderFailSafe.mqh>

class PositionManager {
    protected:  
        CTrade *trade;
        
    public:
        PositionManager(void);
        ~PositionManager(void);

        bool OrderOpen(PositionParams &params);
        bool OrderModify(double sl, double tp);
        bool OrderPartialClose(double volume);   
        bool OrderClose();

        bool isOrderOpen() { return PositionsTotal() != 0;};
};

extern PositionManager *positionManager = new PositionManager;

PositionManager::PositionManager(void): trade(new CTrade) {}
PositionManager::~PositionManager(void) { delete trade; }

bool PositionManager::OrderOpen(PositionParams &params) {
    if (trade.PositionOpen(_Symbol, params.type, params.volume, params.openPrice, params.slPrice, params.tpPrice, "")) return true;
    orderFailSafe.addFailedOpen(params.type);
    return false;
}

bool PositionManager::OrderModify(double sl, double tp) {
    if (trade.PositionModify(_Symbol, sl, tp)) return true;
    orderFailSafe.addFailedModify(sl, tp);
    return false;
}


bool PositionManager::OrderPartialClose(double cVolume) {
    if (trade.PositionClosePartial(_Symbol, cVolume)) return true;
    orderFailSafe.addFailedSizeOut(cVolume);
    return false;
}

bool PositionManager::OrderClose() {    
    ulong oTicket = PositionGetTicket(0);
    if (trade.PositionClose(oTicket, ULONG_MAX)) return true;
    return false;
}