
// 监听native传的参数
export function addParamObserver(callback) {
    var globalEvent = weex.requireModule('globalEvent');
    globalEvent.addEventListener("paramEvent", function (e) {
        if (callback != null) {
            callback(e);
        }
    });
}

// 传递参数给native
export function postParam(param, callback) {
    weex.requireModule('DKParamEvent').param(param, function(res){
        if (callback != null) {
            callback(res);
        }
    })
}