void OnStart() {
    HistorySelect(0, TimeCurrent());
    uint total = HistoryDealsTotal();
    ulong order_id = 0;
    for (uint i = 0; i < total; i++) {
        if((order_id=HistoryOrderSelect(i))>0) {
            
        }

    }
}