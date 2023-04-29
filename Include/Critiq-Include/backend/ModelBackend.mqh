#include <Critiq-Include/backend/PositionManager.mqh>
#include <Critiq-Include/main/Risk.mqh>
#include <Critiq-Include/main/Limits.mqh>  

class ModelBackend : public PositionManager {
    protected:
        Risk *risk;
        Limits *limits;

    public:
        ModelBackend(void);
        ~ModelBackend(void);

        void init();
        void OnTick();
};

extern ModelBackend *modelBackend;

ModelBackend::ModelBackend(void):
                                risk(new Risk),
                                limits(new Limits) {}

ModelBackend::~ModelBackend(void) {}

void ModelBackend::init() {
    risk->init(1.0, 10);
    risk->init_atr_model(14, 1.5);
    limits->init(1.0, 10);

    

}
