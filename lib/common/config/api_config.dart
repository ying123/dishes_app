class Api{
  static String imgUrl="https://www.zlp.ltd/images/";
  static String host="http://192.168.1.3:8080/";
  //static String host="https://www.zlp.ltd/";

  static String wsHost="ws://192.168.1.3:8080/webSocket/";
  //static String wsHost="ws://www.zlp.ltd/webSocket/";

  //获取分类数据
  static String cateGroyList = "api/cateGroy/list";

  //根据商品id获取单个商品详情
  static String foodById = "api/food/foodId/";
  //下单
  static String addOrder = "api/order/add/";

  //获取购物车数据列表
  static String cart_info_listByTableNo="api/orderInfo/list/";

  //编辑
  static String cart_item_edit="api/orderDetail/edit";

  //登录
  static String login = "api/user/login";

  //注册
  static String register = "api/user/register";

  //密码修改
  static String updatePwd = "api/user/updatePwd";
  //获取验证码
  static String getCode = "api/getCode/";
  //获取验证码
  static String uploadFile = "api/upload";

  //付款下单
  static String accounts = "api/order/accounts";
}