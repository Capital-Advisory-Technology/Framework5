#include <Critiq/backend/RiskModel.mqh>
#include <Critiq/main/Calculations.mqh>

class ATR : public RiskModel {
    protected:
        int atr_handle;

        int inpPeriod;
        double inpMultiplier;
        double GetValue();

    public:
        ATR(void);
        ~ATR(void);

        void InitParams(int period, double multiplier);
        virtual OpenTradeParams CalcTradeParams(ENUM_ORDER_TYPE orderType);
};

extern ATR *atr = new ATR;

void ATR::ATR(void) : inpPeriod(14),
                     inpMultiplier(0.7) {}

void ATR::~ATR(void) {
    IndicatorRelease(atr_handle);
}

void ATR::InitParams(int cPeriod, double cMultiplier) {
    inpPeriod = cPeriod;
    inpMultiplier = cMultiplier;

    atr_handle = iATR(NULL, 0, inpPeriod);
}

double ATR::GetValue() {
    double _atr_value[];
    ResetLastError();
    ArraySetAsSeries(_atr_value, true);
    CopyBuffer(atr_handle,0,1,1,_atr_value);
    return NormalizeDouble(_atr_value[0] * inpMultiplier, _Digits);
}

OpenTradeParams ATR::CalcTradeParams(ENUM_ORDER_TYPE orderType) {
    double atr_value = GetValue();

    OpenTradeParams params;
    params.type = ORDER_TYPE_BUY;
    params.volume = CalculateLotSize(rpp, atr_value);
    params.slPrice = GetSLprice(atr_value, params.type);
    params.tpPrice = GetTPprice(atr_value, params.type, posRatio);
    
    return params;
}
