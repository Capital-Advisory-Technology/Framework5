#include <Critiq\backend\RiskModel.mqh>
#include <Critiq\main\Calculations.mqh>

class Risk {
    protected:
        RiskModel *riskModel;
        double inputRpp;
        double posRatio;
        
        double CalcRPP();
        double CalcSLPips();
        
        double RRLostTrade(double cReduction, double cRpp);
        

    public:
        Risk(void);
        ~Risk(void);

        void InitRisk(RiskModel *cRiskModel, double cRpp, double cPosRatio) {
            riskModel = cRiskModel;
            inputRpp = cRpp;
            posRatio = cPosRatio;
        };

        OpenTradeParams CalcTradeParams(ENUM_ORDER_TYPE orderType);
};

extern Risk *risk = new Risk;

Risk::Risk(void) : inputRpp(1.0),
                   posRatio(10) {}

Risk::~Risk(void) {}

double Risk::CalcRPP() {
    // Set risk per position from the input
    double riskPerPos = inputRpp;
    
    // Calculate risk per position by different reducers
    // riskPerPos = RRLostTrade(0.01, riskPerPos);

    return riskPerPos;
}

double Risk::CalcSLPips() {
    double points = riskModel.GetValue();
    return points;
}

OpenTradeParams Risk::CalcTradeParams(ENUM_ORDER_TYPE orderType) {
    double riskPerPosition = CalcRPP();
    double slPips = CalcSLPips();
    
    OpenTradeParams params;
    params.type = orderType;
    params.slPrice = GetSLprice(slPips, params.type);
    params.tpPrice = GetTPprice(slPips, params.type, posRatio);
    params.volume = CalculateLotSize(riskPerPosition, slPips);
    
    return params;
}

// Possibly need to move this to a class
// To count losses as deals go bu in OnTrade 
double Risk::RRLostTrade(double reduction, double cRpp) {
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