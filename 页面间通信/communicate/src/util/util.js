
// 生命常量
export const name = "10"

// 获取url
export function getUrl() {
	if (weex.config.env.platform === "Web") {
		var list = weex.config.bundleUrl.split("/")
        if (list.length >= 2) {
          var url = list[0] + "//" + list[2] + "/"
          return url;
        }
	}
}

// 获取图片路径
export function imageName(name) {
	return getUrl() + "src/images/" + name
}