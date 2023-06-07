#include <Critiq/backend/Model.mqh>
#include<Critiq/main/Risk.mqh>
#include <Critiq/main/PositionManager.mqh>

class ModelBackend {
    protected:
        Risk *risk;
        Model *model;
        
    public:

        ModelBackend(void);
        ~ModelBackend(void);

        void OnTick();
        void setRisk(Risk *cRisk) { risk = cRisk; }
        void setModel(Model *cModel) { model = cModel; }
};

extern ModelBackend *modelBackend;

void ModelBackend::ModelBackend(void) {}
void ModelBackend::~ModelBackend(void) {
    risk.RiskLossReducer(0,0);
    delete risk;
    delete model;
}

void ModelBackend::OnTick() {
    if (!positionManager.isOrderOpen()) {
        // Limits come here
        ENUM_ORDER_TYPE signal = model.GetSignal();
        if (signal == ORDER_TYPE_BUY || signal == ORDER_TYPE_SELL) {
            Print("MODEL: ", signal);
            OpenTradeParams params = risk.CalcTradeParams(signal);
            Print("Type: ", params.type, " volume: ", params.volume, " sl: ", params.slPrice, " tp: ", params.tpPrice);
            positionManager.OrderOpen(params);
        }
    }
}
