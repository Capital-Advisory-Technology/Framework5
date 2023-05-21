class RiskModel {
    protected:
        string path;

    public:
        RiskModel(void){};
        ~RiskModel(void){};

        void Init();
        virtual double GetValue() { return 0; }
};