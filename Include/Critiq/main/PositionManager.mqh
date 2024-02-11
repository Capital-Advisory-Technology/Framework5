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

        void orderOpen(PositionParams &params);
                       
        void orderClose();
        void orderModify(double sl, double tp);
        void orderPartialClose(double volume);   

        bool isOrderOpen() { return PositionsTotal() != 0;};
};

PositionManager *positionManager = new PositionManager;

PositionManager::PositionManager(void): trade(new CTrade) {}

void PositionManager::~PositionManager(void) {
    delete trade;
}

void PositionManager::orderOpen(PositionParams &params) {
    if (!trade.PositionOpen(_Symbol, params.type, params.volume, params.openPrice, params.slPrice, params.tpPrice, "")) {
        orderFailSafe.setFailedOpenType(params.type);
    }
}

void PositionManager::orderModify(double sl, double tp) {
    if (!trade.PositionModify(_Symbol, sl, tp)) {
        orderFailSafe.setFailedModifySLTP(sl, tp);
    }
}

void PositionManager::orderPartialClose(double cVolume) {
    if (!trade.PositionClosePartial(_Symbol, cVolume) && cVolume > 0.0) {
        orderFailSafe.setFailedPartialCloseVolume(cVolume);
    }
}

void PositionManager::orderClose() {
    ulong oTicket = PositionGetTicket(0);
    trade.PositionClose(oTicket, ULONG_MAX);
}
