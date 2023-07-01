#include <Critiq/backend/Model.mqh>

class aATR : public Model {
    protected:
        int inpPeriod;
        int atr_handle;
        double _atr_signal[];

    public:
        aATR(void);
        ~aATR(void);

        void Init(int cPeriod);
        // bool GetSignal();
        double GetValue();
};

extern aATR *matrModel = new aATR;

void aATR::aATR(void) : inpPeriod(14) {}
void aATR::~aATR(void) {}

void aATR::Init(int cPeriod) {
    path = "Critiq-Indicators\\AdaptiveATR";
    Print("PATH: ", path);
    SetIndexBuffer(0, _atr_signal, INDICATOR_DATA);
    ResetLastError();
    ArraySetAsSeries(_atr_signal, true);

    atr_handle = iCustom(NULL, 0, path, cPeriod);
    if(atr_handle==INVALID_HANDLE)
     {
      Print("Error creating \"ATR\" indicator");
     }
}

// bool aATR::GetSignal() {
//     if(CopyBuffer(atr_handle,0,0,2,_atr_signal)==2) {
//         return true;
//     }
//     else {
//         Print("Error copying buffer");
//         return false;
//     }
// }

double aATR::GetValue() {
    if(CopyBuffer(atr_handle,0,0,2,_atr_signal)==2) {
        return _atr_signal[1];
    }
    else {
        Print("Error copying buffer");
        return 0;
    }
}
