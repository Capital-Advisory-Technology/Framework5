#include <Critiq/backend/Model.mqh>
#include <Critiq/backend/RiskModel.mqh>
#include <Critiq/main/PositionManager.mqh>

class ModelBackend {
    protected:
        Model *model;
        RiskModel *riskModel;
        
    public:

        ModelBackend(void);
        ~ModelBackend(void);

        void OnTick();
        void setModel(Model *cModel) { model = cModel; }
        void setRiskModel(RiskModel *cRiskModel) { riskModel = cRiskModel; }
};

extern ModelBackend *modelBackend;

void ModelBackend::ModelBackend(void) {}
void ModelBackend::~ModelBackend(void) {
    delete model;
    delete riskModel;
}

void ModelBackend::OnTick() {
    if (!positionManager.isOrderOpen()) {
        // Limits come here
        ENUM_ORDER_TYPE signal = model.GetSignal();
        if (signal == ORDER_TYPE_BUY || signal == ORDER_TYPE_SELL) {
            Print("MODEL: ", signal);
            OpenTradeParams params = riskModel.CalcTradeParams(signal);
            Print("Type: ", params.type, "volume: ", params.volume, "sl: ", params.slPrice, "tp: ", params.tpPrice);
            positionManager.OrderOpen(params);
        }
    }
}
