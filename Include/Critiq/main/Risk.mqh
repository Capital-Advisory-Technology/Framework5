#include <Critiq\backend\RiskModel.mqh>
#include <Critiq\main\Calculations.mqh>

class Risk {
    protected:
        RiskModel *riskModel;
        double rpp;
        double posRatio;
        
        double CalcRPP();
        double CalcSLPips();
        
        

    public:
        Risk(void);
        ~Risk(void);

        void InitRisk(RiskModel *cRiskModel, double cRpp, double cPosRatio) {
            riskModel = cRiskModel;
            rpp = cRpp;
            posRatio = cPosRatio;
        };

        OpenTradeParams CalcTradeParams(ENUM_ORDER_TYPE orderType);
        double RiskLossReducer(int nLosses, double reduction);
};

extern Risk *risk = new Risk;

Risk::Risk(void) : rpp(1.0),
                   posRatio(10) {}

Risk::~Risk(void) {}

double Risk::CalcRPP() {
    return rpp;
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
double Risk::RiskLossReducer(int nLosses, double reduction) {
    if (nLosses == 0 || reduction == 0) {
        return rpp;
    } else {
            HistorySelect(0, TimeCurrent());
        // string   name;
        uint     total=HistoryDealsTotal();
        ulong    ticket=0;
        double   price;
        double   profit;
        datetime time;
        string   symbol;
        long     type;
        long     entry;

        for(uint i=total; i>0; i--) {
            if((ticket=HistoryDealGetTicket(i))>0) {
                price =HistoryDealGetDouble(ticket,DEAL_PRICE);
                time  =(datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
                symbol=HistoryDealGetString(ticket,DEAL_SYMBOL);
                type  =HistoryDealGetInteger(ticket,DEAL_TYPE);
                entry =HistoryDealGetInteger(ticket,DEAL_ENTRY);
                profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);

                if(price && time && symbol==Symbol()) {
                    Print("Ticket: ", ticket, " Price: ", price, " Time: ", time, " Symbol: ", symbol, " Type: ", type, " Entry: ", entry, " Profit: ", profit);
                }
            }
        }

        return rpp;
    }
}