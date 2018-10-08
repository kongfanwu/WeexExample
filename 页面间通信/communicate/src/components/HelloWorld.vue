<template>
  <text class="message" @click="toBack" >{{ value }}</text>
</template>

<script>
  var navigator = weex.requireModule('navigator');
  const modal = weex.requireModule('modal');
  import * as paramManager from '../util/paramManager'
  import * as util from '../util/util'
  
  import page from './page.vue'

  export default {
    components: {
      page,
    },
    data:function () {
        return {
          value: "hello world."
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
        var param = {"pageName": "HelloWorld", 
                     "data": {
                       "key1": "value1"
                      }
                    };
        paramManager.postParam(param, function(res){
          modal.toast({message: res, duration: 1});
        })

        navigator.push({
				url: util.getUrl() + "dist/components/page.js",
				animated: "true"
				}, event => {
				})
      },

      block: function(title, callback) {
        if (callback != null) {
          callback("123");
        }
      },
    }
  }
</script>
