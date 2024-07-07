#include <A&A/risk/Risk.mqh>
#include <A&A/common/Calculations.mqh>

class Atr : public Risk {
    protected:
        int atr_handle;

        int inpPeriod;
        double inpMultiplier;

    public:
        Atr(void);
        ~Atr(void);

        void Init(int period, double multiplier);
        virtual double getPipValue();
};

extern Atr *atr;

void Atr::Atr(void) : inpPeriod(14),
                     inpMultiplier(0.7) {}

void Atr::~Atr(void) {
    IndicatorRelease(atr_handle);
}

void Atr::Init(int cPeriod, double cMultiplier) {
    inpPeriod = cPeriod;
    inpMultiplier = cMultiplier;

    atr_handle = iATR(NULL, 0, inpPeriod);
}

double Atr::getPipValue() {
    double _atr_value[];
    ResetLastError();
    ArraySetAsSeries(_atr_value, true);
    CopyBuffer(atr_handle,0,1,1,_atr_value);
    return NormalizeDouble(_atr_value[0] * inpMultiplier, _Digits);
}
