class Model {
    protected:
        string path;

    public:
        Model(void){};
        ~Model(void){};

        void Init();
        virtual ENUM_ORDER_TYPE GetSignal() { return 0; }
};