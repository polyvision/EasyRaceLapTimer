import alt from '../alt';
var FunnelConfigurationWebUtil = require('../webutil/funnel_configuration_webutil.js');
var FunnelConfigurationStore = require('../stores/funnel_configuration_store.js');

class FunnelConfigurationActions {
  list(id,amount_data,selected_dn,group_dn_data){
    var self = this;
    FunnelConfigurationWebUtil.list(id,amount_data,selected_dn,group_dn_data,function(err,result){
      if(!err){
        self.dispatch(result.body);
      }
    });
  }

  addToShoppingCart(data){
    var self = this;
    FunnelConfigurationWebUtil.addToShoppingCart(data,function(err,result){
      if(!err){
        //self.dispatch(result.body);
        window.location.replace("/shop/shopping_cart");
      }
    });
  }
}

export default alt.createActions(FunnelConfigurationActions);
