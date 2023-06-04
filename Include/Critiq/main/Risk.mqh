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
