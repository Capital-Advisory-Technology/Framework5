#include <Critiq/backend/Model.mqh>
#include <Critiq/backend/RiskModel.mqh>
#include <Critiq/main/PositionManager.mqh>

class ModelBackend {
    protected:
        Model *model;
        RiskModel *riskModel;
        
    public:

        ModelBackend(void){};
        ~ModelBackend(void){};

        void OnTick();
        void setModel(Model *cModel) { model = cModel; }
        void setRiskModel(RiskModel *cRiskModel) { riskModel = cRiskModel; }
};

extern ModelBackend *modelBackend;

void ModelBackend::OnTick() {
    ENUM_ORDER_TYPE signal = model.GetSignal();
    if (signal == ORDER_TYPE_BUY) {
        Print("MB: BUY");
        riskModel.GetValue();
    } else if (signal == ORDER_TYPE_SELL) {
        Print("MB: SELL");
        riskModel.GetValue();
    }
}
