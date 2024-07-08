// #include <A&A/backend/RiskManager.mqh>
#include <A&A/common/Structures.mqh>
#include <A&A/backend/PositionManager.mqh>
#include <A&A/backend/Limits.mqh>
#include <A&A/signal/Signal.mqh>
#include <A&A/risk/Risk.mqh>

class Frame {
    protected:
        Signal *signal;
        Risk *risk;
        Limits *limits;

    private:
        // main risk params
        double riskPercent;
        double riskMax;
        double riskToReward;

    public:
        Frame(void);
        ~Frame(void);

        void setRisk(Risk *cRisk) { risk = cRisk; }
        
        void setSignal(Signal *cSignal) { signal = cSignal; }

        void setLimits(int cTimeFrom, int cTimeTo) { 
            limits = new Limits;
            limits.setIntraDay(cTimeFrom, cTimeTo);
        };
        
        void initRiskParams(double cRPP = 1, double cRM = 25, double cRR = 5) {    
            riskPercent = cRPP;
            riskMax = cRM;
            riskToReward = cRR;
        };
        
        void initRiskReducer(double cRPR = 0) {
            riskPercentReduce = cRPR; 
        }

        void Run();

    private:
        double riskPercentReduce;
        datetime prevBarTime;
        bool isNewBar();
        PositionParams getOrderParams(ENUM_ORDER_TYPE);
};

extern Frame *frame; // create pointer to object

void Frame::Frame(void) { // constructooor
}

void Frame::~Frame(void) {
    delete signal;
    delete risk;
}

void Frame::Run() {

    if (!isNewBar()) return;
       
    // Do you mean to check opened position situation?
    // as in for example, we have 3 trades open, each with risk 2%, maxRisk is at 6%
    // one trade has SL at breakeven, so this one doesn't count to the max risk,
    // but the other 2 do, so we dont open a new trade?
    // if not, then i would suggest to set maxRisk and maxPositions and then calculate the risk per position
    // if (!riskManager.checkMaxRisk()) return;

    // if (!profitsys.refresh()) return;

    if (!limits.refresh()) return;

    // check for signal

    switch (signal.GetSignal()) {
        case SIGNAL_LONG:
            positionManager.orderOpen(getOrderParams(ORDER_TYPE_BUY));
        case SIGNAL_SHORT:
            positionManager.orderOpen(getOrderParams(ORDER_TYPE_SELL));
        case SIGNAL_IGNORE:
            break;
    }

    /*
        service deals (close, modify), ignore or hard stop
        riskManager.refresh();
        profitSystem.refresh();

        check for limitations, ignore or hard stop
        limits.?
    */
    // if we check opened positions here then we would instantly check
    // the newest position from the previous switch statement
    if (PositionsTotal() > 0) {
        for (int i = 0; i < PositionsTotal(); i++) {
            ulong ticket = PositionGetTicket(i);
            // profitSystem.refresh(ticket);
        }
    }
}

PositionParams Frame::getOrderParams(ENUM_ORDER_TYPE orderType) {
    // Get final risk value, get stop loss value in pips from risk model
    double riskPerPosition = CalcPosRisk(riskPercentReduce, riskPercent);
    double slPips = risk.getPipCount();
    
    // New structure, fill all values and return
    PositionParams params;
    params.type = orderType;
    params.openPrice = UsedPrice(orderType);
    params.slPrice = CalcSL(slPips, params.type);
    params.tpPrice = CalcTP(slPips, params.type, riskToReward);
    params.volume = CalcLotSize(riskPerPosition, slPips);

    return params;
}

bool Frame::isNewBar() {
    datetime barTime = iTime(_Symbol, _Period, 0);

    if (barTime != prevBarTime) {
        prevBarTime = barTime;
        return true;
    }

    return false;
}