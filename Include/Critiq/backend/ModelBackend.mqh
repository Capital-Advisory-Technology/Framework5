#include <Critiq/backend/Model.mqh>
#include <Critiq/main/Limits.mqh>
#include <Critiq/main/ProfitSystem.mqh>

class ModelBackend {
    protected:
        Risk *risk;
        Model *model;
        Limits *limits;
        ProfitSystem *profitSystem;
        
        datetime prevBarTime;
        void orderErrorHandle();
        bool isNewBar();

    public:
        ModelBackend(void);
        ~ModelBackend(void);

        void OnTick();
        void setRisk(Risk *cRisk) { risk = cRisk; }
        void setModel(Model *cModel) { model = cModel; }
        void setLimits(Limits *cLimits) { limits = cLimits; }
        void setProfitSystem(double cT1, double cT2, double cS1, double cS2, double cBE) {
            profitSystem = new ProfitSystem(cT1, cT2, cS1, cS2, cBE);
        }
};

extern ModelBackend *modelBackend;

void ModelBackend::ModelBackend(void) {}

void ModelBackend::~ModelBackend(void) {
    delete risk;
    delete model;
    delete limits;
    delete profitSystem;
    delete positionManager;
    delete orderFailSafe;
}

void ModelBackend::OnTick() {
    if (isNewBar()) {
        // Open position if intraday allowed and no order open
        if (!positionManager.isOrderOpen()) {
            if (limits.intraDayAllowed()) {
                ENUM_ORDER_TYPE signal = model.getSignal();
                if (signal == ORDER_TYPE_BUY || signal == ORDER_TYPE_SELL) { 
                    profitSystem.clearFlags();   
                    PositionParams tradeParams = risk.getOrderParams(signal);
                    positionManager.orderOpen(tradeParams);
                }
            }
        // Position management     
        } else {
            bool breakEven = profitSystem.breakEven();
            bool moveStops = profitSystem.moveStops();
            bool takePartials = profitSystem.takePartials();
        }
    }

    orderErrorHandle();
}

void ModelBackend::orderErrorHandle() {
    // Failed open
    if (orderFailSafe.isFailedOpen()) {
        ENUM_ORDER_TYPE signal = orderFailSafe.getFailedOpenType();
        profitSystem.clearFlags();
        PositionParams tradeParams = risk.getOrderParams(signal);
        positionManager.orderOpen(tradeParams);
    }
    // Failed modify
    if (orderFailSafe.isFailedModify()) {
        double sl = orderFailSafe.getFailedModifySL();
        double tp = orderFailSafe.getFailedModifyTP();
        positionManager.orderModify(sl, tp);
    }
    // Failed partial close
    if (orderFailSafe.isFailedPartialClose()) {
        double volume = orderFailSafe.getFailedPartialCloseVolume();
        positionManager.orderPartialClose(volume);
    }
}

bool ModelBackend::isNewBar() {
    datetime barTime = iTime(_Symbol, _Period, 0);
    if (barTime != prevBarTime) {
        prevBarTime = barTime;
        return true;
    }
    return false;
}