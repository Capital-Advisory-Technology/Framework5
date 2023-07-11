#include <Trade/Trade.mqh>

#include <Critiq/main/Risk.mqh>
#include <Critiq/main/OrderFailSafe.mqh>
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
    if (!trade.PositionOpen(_Symbol, params.type, params.volume, params.openPrice, params.slPrice, params.tpPrice, "")) {
        orderFailSafe.setFailedOpenType(params.type);
    }
}

void PositionManager::OrderModify(double sl, double tp) {
    if (!trade.PositionModify(_Symbol, sl, tp)) {
        orderFailSafe.setFailedModifySLTP(sl, tp);
    }
}

void PositionManager::OrderPartialClose(double cVolume) {
    if (!trade.PositionClosePartial(_Symbol, cVolume) && cVolume > 0.0) {
        orderFailSafe.setFailedPartialCloseVolume(cVolume);
    }
}

void PositionManager::OrderClose() {
    ulong oTicket = PositionGetTicket(0);
    trade.PositionClose(oTicket, ULONG_MAX);
}
