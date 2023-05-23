#include <Critiq/backend/RiskModel.mqh>
#include <Critiq/main/Calculations.mqh>

class Atr : public RiskModel {
    protected:
        int atr_handle;

        int inpPeriod;
        double inpMultiplier;
        double GetValue();

    public:
        Atr(void);
        ~Atr(void);

        void InitParams(int period, double multiplier);
        virtual OpenTradeParams CalcTradeParams(ENUM_ORDER_TYPE orderType);

};

extern Atr *atr = new Atr;

void Atr::Atr(void) : inpPeriod(14),
                     inpMultiplier(0.7) {}

void Atr::~Atr(void) {
    IndicatorRelease(atr_handle);
}

void Atr::InitParams(int cPeriod, double cMultiplier) {
    inpPeriod = cPeriod;
    inpMultiplier = cMultiplier;

    atr_handle = iATR(NULL, 0, inpPeriod);
}

double Atr::GetValue() {
    double _atr_value[];
    ResetLastError();
    ArraySetAsSeries(_atr_value, true);
    CopyBuffer(atr_handle,0,1,1,_atr_value);
    return NormalizeDouble(_atr_value[0] * inpMultiplier, _Digits);
}

OpenTradeParams Atr::CalcTradeParams(ENUM_ORDER_TYPE orderType) {
    double atr_value = GetValue();

    OpenTradeParams params;
    params.type = ORDER_TYPE_BUY;
    params.volume = CalculateLotSize(rpp, atr_value);
    params.slPrice = GetSLprice(atr_value, params.type);
    params.tpPrice = GetTPprice(atr_value, params.type, posRatio);
    
    gLog.Debug(DoubleToString(params.volume));
    return params;
}
