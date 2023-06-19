class RiskModel {

    public:
        RiskModel(void){};
        ~RiskModel(void){};

        virtual double GetValue()=0;
};