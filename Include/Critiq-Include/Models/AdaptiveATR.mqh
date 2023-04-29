#include <Critiq-Include/Models/ReturnSignal.mqh>
#include <Critiq-Include/main/Risk.mqh>

class AdaptiveATR {
    protected:
        int atr_handle;

        int inpPeriod;

        double _atr_signal[];

    public:
        AdaptiveATR(void);
        ~AdaptiveATR(void);

        void init(int period);
        double GetLast();

};

extern AdaptiveATR *adaptiveATR = new AdaptiveATR;

void AdaptiveATR::AdaptiveATR(void) : inpPeriod(14) {}
void AdaptiveATR::~AdaptiveATR(void) {}

void AdaptiveATR::init(int period) {
    Print("HERE69");
    SetIndexBuffer(0, _atr_signal, INDICATOR_DATA);
    ResetLastError();
    ArraySetAsSeries(_atr_signal, true);

    atr_handle = iCustom(NULL, 0, 
    "Critiq-Indicators\\AdaptiveATR", period);
}

double AdaptiveATR::GetLast() {
    CopyBuffer(atr_handle,0,0,2,_atr_signal);
    return _atr_signal[0];
}
