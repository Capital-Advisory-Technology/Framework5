#include <Critiq-Include/Models/GenericModel.mqh>

class MATR : public Model {
    protected:
        int inpPeriod;
        int atr_handle;
        double _atr_signal[];

    public:
        MATR(void);
        ~MATR(void);

        void Init(int cPeriod);
        bool GetSignal();
};

extern MATR *matrModel = new MATR;

void MATR::MATR(void) : inpPeriod(14) {}
void MATR::~MATR(void) {}

void MATR::Init(int cPeriod) {
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

bool MATR::GetSignal() {
    if(CopyBuffer(atr_handle,0,0,2,_atr_signal)==2) {
        return true;
    }
    else {
        Print("Error copying buffer");
        return false;
    }
}
