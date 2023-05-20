#include <Critiq/main/Risk.mqh>
#include <Critiq/main/Limits.mqh>
#include <Critiq/main/PositionManager.mqh>
#include <Critiq/backend/Model.mqh>

class ModelBackend {
    public:
        Risk *risk;
        Limits *limits;
        PositionManager *positionManager;
        Model *model;

        ModelBackend(void);
        ~ModelBackend(void);

        void Init();
        void OnTick();

        void InitModel(Model *cModel) {
            model = cModel;
        }
};

extern ModelBackend *modelBackend;

ModelBackend::ModelBackend(void):
                                risk(new Risk),
                                limits(new Limits),
                                positionManager(new PositionManager) {}

ModelBackend::~ModelBackend(void) {}

void ModelBackend::Init() {
    
}

void ModelBackend::OnTick() {
     if (!limits.getLimits()) {
        if (model.GetSignal() == ORDER_TYPE_BUY) {
            if (!positionManager.isOrderOpen()) {
                risk.get_atr_model(ORDER_TYPE_BUY);
                positionManager.OrderOpen(
                    ORDER_TYPE_BUY,
                    risk.get_volume(),
                    risk.get_slPrice(),
                    risk.get_tpPrice()
                    );
            }
        } else if (model.GetSignal() == ORDER_TYPE_SELL) {
            if (!positionManager.isOrderOpen()) {
                risk.get_atr_model(ORDER_TYPE_SELL);
                positionManager.OrderOpen(
                    ORDER_TYPE_SELL,
                    risk.get_volume(),
                    risk.get_slPrice(),
                    risk.get_tpPrice());
            }
        }
    }
    
}
