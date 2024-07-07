#include <A&A/common/Calculations.mqh>
#include <A&A/common/Structures.mqh>
#include <A&A/risk/Risk.mqh>

// Placeholder for risk model.
// Handles order values

class RiskManager {
    protected:
        Risk *risk;
        PositionParams openPositionParams;
    
    private:
        double inputRpp;
        double inputRppReducePerLoss;
        double inputPosRatio;
        double inputMaxRisk;

        double getPosRisk();
        double getStopLossPips();
        
        double getLossReducedRisk(double cReduction, double cRpp);
        
    public:
        RiskManager(void);
        ~RiskManager(void);

        void Init(Risk *crisk,
                    double cRpp = 1,
                    double cInputPosRatio = 1,
                    double cInputRppReducePerLoss = 0,
                    double cInputMaxRisk = 25) 
        {
            risk = crisk;
            inputRppReducePerLoss = cInputRppReducePerLoss;
            inputRpp = cRpp;
            inputMaxRisk = cInputMaxRisk;
        };

        PositionParams getOrderParams(ENUM_ORDER_TYPE orderType);
        
        virtual double getPipValue() { return 0; }
};

extern RiskManager *riskManager;

RiskManager::RiskManager(void) : inputRpp(1.0),
                                 inputPosRatio(10) {}

RiskManager::~RiskManager(void) { delete risk; }

// Set new order params, used for 
PositionParams RiskManager::getOrderParams(ENUM_ORDER_TYPE orderType) {
    // Get final risk value, get stop loss value in pips from risk model
    double riskPerPosition = getPosRisk();
    double slPips = risk.getPipValue();
    
    // New structure, fill all values and return
    PositionParams params;
    params.type = orderType;
    params.openPrice = UsedPrice(orderType);
    params.slPrice = CalcSL(slPips, params.type);
    params.tpPrice = CalcTP(slPips, params.type, inputPosRatio);
    params.volume = CalcLotSize(riskPerPosition, slPips);

    return params;
}

// Return final risk value (%)
double RiskManager::getPosRisk() {
    
    // Recalculate for all risk reducers
    double riskPerPos = getLossReducedRisk(inputRppReducePerLoss, inputRpp);

    return riskPerPos;
}

// Return reduced risk if applicable
double RiskManager::getLossReducedRisk(double reduction, double cRpp) {
    if (reduction == 0) return cRpp; 

    HistorySelect(0, TimeCurrent());
        uint total = HistoryDealsTotal();
        ulong ticket = 0;
        double profit;
        double reducedRisk = cRpp;

        for (uint i=total; i>0; i--) {
            if ((ticket = HistoryDealGetTicket(i)) > 0) {
                profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);
                if (profit < 0) reducedRisk -= reducedRisk * reduction;
                else if (profit == .0) continue;
                else break;
            }
        }
    return NormalizeDouble(reducedRisk, 4);
}