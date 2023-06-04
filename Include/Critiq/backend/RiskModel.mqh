struct OpenTradeParams {
    ENUM_ORDER_TYPE type;
    double volume;
    double openPrice;
    double slPrice;
    double tpPrice;
};

class RiskModel {
    protected:
        double rpp;
        double posRatio;

    public:
        RiskModel(void);
        ~RiskModel(void);

        virtual double GetValue()=0;

};

RiskModel::RiskModel(void) : rpp(1.0),
                             posRatio(10) {}

RiskModel::~RiskModel(void) {}