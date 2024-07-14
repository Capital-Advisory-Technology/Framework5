#include <A&A/backend/Limits.mqh>
#include <A&A/backend/PositionManager.mqh>
#include <A&A/backend/ProfitSystem.mqh>
#include <A&A/common/Structures.mqh>
#include <A&A/risk/Risk.mqh>
#include <A&A/signal/Signal.mqh>

class Frame {
    protected:
        Signal       *signal;
        Risk         *risk;
        Limits       *limits;
        ProfitSystem *profitSystem;

    private:
        // main risk params
        double riskPercent;
        double riskMax;
        double riskToReward;

    public:
        void setRisk(Risk *cRisk) { risk = cRisk; }

        void setSignal(Signal *cSignal) { signal = cSignal; }

        void setLimits(int cTimeFrom, int cTimeTo) {
            limits = new Limits;
            limits.setIntraDay(cTimeFrom, cTimeTo);
        };

        void setProfitSystem(double cBE, double cT1, double cT2, double cS1, double cS2) {
            profitSystem = new ProfitSystem(cBE, cT1, cT2, cS1, cS2);
        };

        void init(double cRPP = 1, double cRM = 25, double cRR = 5) {
            riskPercent  = cRPP;
            riskMax      = cRM;
            riskToReward = cRR;
        };

        void initRiskReducer(double cRPR = 0) {
            riskPercentReduce = cRPR;
        }

        void Run();
        
        ~Frame(void) { 
            delete signal;
            delete risk;
            delete limits;
            delete profitSystem;
        }

    private:
        double         riskPercentReduce;
        datetime       prevBarTime;
        bool           isNewBar();
        PositionParams getOrderParams(ENUM_ORDER_TYPE);
};

extern Frame *frame;   // create pointer to object

void Frame::Run() {

    if(!isNewBar())
        return;

    /*
        service deals (close, modify), ignore or hard stop
        riskManager.refresh();
        profitSystem.refresh();

        check for limitations, ignore or hard stop
        limits.?
    */
    for(int i = 0; i < PositionsTotal(); i++) {
        ulong ticket = PositionGetTicket(i);
        if(!PositionSelectByTicket(ticket)) continue;
        if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;

        double bkPrice = profitSystem.breakeven();
        if(bkPrice != 0)
            positionManager.orderModify(ticket, bkPrice, PositionGetDouble(POSITION_TP));

        double profitSl1 = profitSystem.profitZone1();
        if(profitSl1 != 0)
            positionManager.orderModify(ticket, profitSl1, PositionGetDouble(POSITION_TP));

        double profitSl2 = profitSystem.profitZone2();
        if(profitSl2 != 0)
            positionManager.orderModify(ticket, profitSl2, PositionGetDouble(POSITION_TP));
    }

    // Do you mean to check opened position situation?
    // as in for example, we have 3 trades open, each with risk 2%, maxRisk is at 6%
    // one trade has SL at breakeven, so this one doesn't count to the max risk,
    // but the other 2 do, so we dont open a new trade?
    // if not, then i would suggest to set maxRisk and maxPositions and then calculate the risk per position
    // if (!riskManager.checkMaxRisk()) return;

    // if (!profitsys.refresh()) return;

    if(!limits.refresh())
        return;

    // check for signal

    switch(signal.getSignal()) {
        case SIGNAL_BUY:
            positionManager.orderOpen(getOrderParams(ORDER_TYPE_BUY));
        case SIGNAL_SELL:
            positionManager.orderOpen(getOrderParams(ORDER_TYPE_SELL));
        case SIGNAL_IGNORE:
            break;
    }
}

PositionParams Frame::getOrderParams(ENUM_ORDER_TYPE orderType) {
    // Get final risk value, get stop loss value in pips from risk model
    double riskPerPosition = CalcPosRisk(riskPercentReduce, riskPercent);
    double slPips          = risk.getPipCount();

    // New structure, fill all values and return
    PositionParams params;
    params.type      = orderType;
    params.openPrice = UsedPrice(orderType);
    params.slPrice   = CalcSL(slPips, params.type);
    params.tpPrice   = CalcTP(slPips, params.type, riskToReward);
    params.volume    = CalcLotSize(riskPerPosition, slPips);

    return params;
}

bool Frame::isNewBar() {
    datetime barTime = iTime(_Symbol, _Period, 0);

    if(barTime != prevBarTime) {
        prevBarTime = barTime;
        return true;
    }

    return false;
}