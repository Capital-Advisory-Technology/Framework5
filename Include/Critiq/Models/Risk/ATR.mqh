#include <Critiq/backend/RiskModel.mqh>

class ATR : public RiskModel {
    protected:
        int atr_handle;
        double atr_value;

        int inpPeriod;
        double inpMultiplier;

    public:
        ATR(void);
        ~ATR(void);

        void Init(int period, double multiplier);
        virtual double GetValue();
};

extern ATR *atr = new ATR;

void ATR::ATR(void) : inpPeriod(14),
                     inpMultiplier(0.7) {}

void ATR::~ATR(void) {}

void ATR::Init(int cPeriod, double cMultiplier) {
    inpPeriod = cPeriod;
    inpMultiplier = cMultiplier;

    atr_handle = iATR(NULL, 0, inpPeriod);
}

double ATR::GetValue() {
    double _atr_value[];

    ResetLastError();
    ArraySetAsSeries(_atr_value, true);
    CopyBuffer(atr_handle,0,1,1,_atr_value);
    Print("ATR: ", _atr_value[0], " Multiplied: ", _atr_value[0] * inpMultiplier);
    return NormalizeDouble(_atr_value[0] * inpMultiplier, _Digits);
}