#include <Critiq\backend\RiskModel.mqh>
#include <Critiq\main\Calculations.mqh>

class Risk {
    private:
        RiskModel *riskModel;
        double rpp;
        double posRatio;

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

OpenTradeParams Risk::CalcTradeParams(ENUM_ORDER_TYPE orderType) {
    OpenTradeParams params;
    
    return params;
}
