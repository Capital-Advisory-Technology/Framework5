#include <Critiq/backend/RiskModel.mqh>
#include <Critiq/main/Calculations.mqh>
#include <Critiq/main/ProfitSystem.mqh>
#include <Critiq/common/Structures.mqh>


class Risk {
    protected:
        RiskModel *riskModel;
        PositionParams openPositionParams;
        
        double inputRpp;
        double inputRppReducePerLoss;
        double inputPosRatio;
        
        double CalcRPP();
        double CalcSLPips();
        
        double RRPerLoss(double cReduction, double cRpp);
        

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

        PositionParams CalcTradeParams(ENUM_ORDER_TYPE orderType);
        
};

extern Risk *risk = new Risk;

Risk::Risk(void) : inputRpp(1.0),
                   inputPosRatio(10) {}

Risk::~Risk(void) {}

double Risk::CalcRPP() {
    // Set risk per position from the input
    double riskPerPos = inputRpp;
    
    // Calculate risk per position by different reducers
    riskPerPos = RRPerLoss(inputRppReducePerLoss, riskPerPos);

    return riskPerPos;
}

double Risk::CalcSLPips() {
    double points = riskModel.GetValue();
    return points;
}

PositionParams Risk::CalcTradeParams(ENUM_ORDER_TYPE orderType) {
    double riskPerPosition = CalcRPP();
    double slPips = CalcSLPips();
    
    PositionParams params;
    params.type = orderType;
    params.openPrice = GetOpenPrice(orderType);
    params.slPrice = GetSLprice(slPips, params.type);
    params.tpPrice = GetTPprice(slPips, params.type, inputPosRatio);
    params.volume = CalculateLotSize(riskPerPosition, slPips);

    return params;
}

// Possibly need to move this to a class
// To count losses as deals go bu in OnTrade 
double Risk::RRPerLoss(double reduction, double cRpp) {
    if (reduction == 0) {
        return cRpp;
    } else {
        HistorySelect(0, TimeCurrent());
        uint     total=HistoryDealsTotal();
        ulong    ticket=0;
        double   profit;
        double reducedRisk = cRpp;

        for(uint i=total; i>0; i--) {
            if((ticket=HistoryDealGetTicket(i))>0) {
                profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);
                if (profit < 0) reducedRisk -= reducedRisk * reduction;
                else if(profit == .0) continue;
                else break;
            }
        }

        return NormalizeDouble(reducedRisk, 4);
    }
}