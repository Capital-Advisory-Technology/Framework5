#include <Trade/Trade.mqh>
#include <A&A/common/Structures.mqh>
#include <A&A/common/Calculations.mqh>

class PositionManager {
    protected:  
        CTrade  *trade;
    public:
        PositionManager(void) { trade = new CTrade; }
        ~PositionManager(void) { delete trade; }

        void orderOpen(PositionParams &params);
                       
        void orderClose();
        void orderModify(ulong ticket, double sl, double tp);
        void orderPartialClose(double volume);

        bool isOrderOpen() { return PositionsTotal() != 0;};
};
 
PositionManager *positionManager = new PositionManager;

void PositionManager::orderOpen(PositionParams &params) {
    if (!trade.PositionOpen(_Symbol, params.type, params.volume, params.openPrice, params.slPrice, params.tpPrice, "")) {
        SetUserError(1);
        return;
    }
}

void PositionManager::orderModify(ulong ticket, double sl, double tp) {
    if (!trade.PositionModify(ticket, sl, tp)) {
        SetUserError(2);
        return;
    }
}

void PositionManager::orderPartialClose(double cVolume) {
    if (!trade.PositionClosePartial(_Symbol, cVolume) && cVolume > 0.0) {
        SetUserError(3);
        return;
    }
}

void PositionManager::orderClose() {
    ulong oTicket = PositionGetTicket(0);
    trade.PositionClose(oTicket, ULONG_MAX);
}
