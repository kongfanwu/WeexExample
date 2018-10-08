<template>
  <text class="message" @click="toBack" >{{ value }}</text>
</template>

<script>
  var navigator = weex.requireModule('navigator');
  const modal = weex.requireModule('modal');
  import * as paramManager from '../util/paramManager'

  export default {
    data:function () {
        return {
          value: "Now, let's use Vue.js to build your Weex app."
        }
    },
    created:function() {
        var self = this;
        paramManager.addParamObserver(function(data){
          self.value = JSON.stringify(data);
        })
        
    },
    methods: {
      toBack: function (event) { 
        var param = {"pageName": "page", 
                     "data": {
                       "key2": "value2"
                      }
                    };
        paramManager.postParam(param, function(res){
          modal.toast({message: res, duration: 1});
        })

        navigator.pop({animated: "true"})
      },

      block: function(title, callback) {
        if (callback != null) {
          callback("123");
        }
      },
    }
  }
</script>
