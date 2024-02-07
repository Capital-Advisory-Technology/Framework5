#include <Critiq/backend/RiskModel.mqh>
#include <Critiq/main/Calculations.mqh>

class Atr : public RiskModel {
    protected:
        int atr_handle;

        int inpPeriod;
        double inpMultiplier;

    public:
        Atr(void);
        ~Atr(void);

        void InitParams(int period, double multiplier);
        virtual double GetValue();
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
