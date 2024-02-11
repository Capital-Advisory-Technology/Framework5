#include <Critiq/backend/RiskModel.mqh>
#include <Critiq/main/Calculations.mqh>
#include <Critiq/main/ProfitSystem.mqh>
#include <Critiq/common/Structures.mqh>

// Placeholder for risk model.
// Handles order values 

class Risk {
    protected:
        RiskModel *riskModel;
        PositionParams openPositionParams;
        
        double inputRpp;
        double inputRppReducePerLoss;
        double inputPosRatio;
        
        double getRisk();
        double getStopLossPips();
        
        double getLossReducedRisk(double cReduction, double cRpp);
        
    public:
        Risk(void);
        ~Risk(void);

        void InitRisk(
            RiskModel *cRiskModel,
            double cRpp,
            double cInputRppReducePerLoss,
            double cInputPosRatio
        ) {
            riskModel = cRiskModel;
            inputRppReducePerLoss = cInputRppReducePerLoss;
            inputRpp = cRpp;
        };

        PositionParams getOrderParams(ENUM_ORDER_TYPE orderType);
        
};

extern Risk *risk;

Risk::Risk(void) : inputRpp(1.0),
                   inputPosRatio(10) {}

Risk::~Risk(void) {}

// Set new order params, used for 
PositionParams Risk::getOrderParams(ENUM_ORDER_TYPE orderType) {
    // Get final risk value, get stop loss value in pips from risk model
    double riskPerPosition = getRisk();
    double slPips = riskModel.getPipValue();
    
    // New structure, fill all values and return
    PositionParams params;
    params.type = orderType;
    params.openPrice = GetOpenPrice(orderType);
    params.slPrice = GetSLprice(slPips, params.type);
    params.tpPrice = GetTPprice(slPips, params.type, inputPosRatio);
    params.volume = CalculateLotSize(riskPerPosition, slPips);

    return params;
}

// Return final risk value (%)
double Risk::getRisk() {
    // Set original risk
    double riskPerPos = inputRpp;
    
    // Recalculate for all risk reducers
    riskPerPos = getLossReducedRisk(inputRppReducePerLoss, riskPerPos);

    return riskPerPos;
}

// Return reduced risk if applicable
double Risk::getLossReducedRisk(double reduction, double cRpp) {
    
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