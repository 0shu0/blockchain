import request from "./request";

export function addShop(params) {
    return request.post('/shop/save', params).then(res => {
        return res;
    }).catch(err => {
        console.error("添加商品失败：", err);
        throw err;
    });
}

export function deleteShop(id) {
    return request.delete(`/shop/deleteById/${id}`).then(res => {
        return res;
    }).catch(err => {
        console.error("删除商品失败：", err);
        throw err;
    });
}

export function getAllShop() {
    return request.get('/shop/findAll').then(res => {
        return res.data;
    }).catch(err => {
        console.error("加载商品列表失败：", err);
        return [];
    });
}

export function getShopById(id) {
    return request.get(`/shop/findById/${id}`).then(res => {
        return res.data;
    }).catch(err => {
        console.error("查询商品失败：", err);
        throw err;
    });
}

export function getShopByCode(code) {
    return request.get(`/shop/findByTraceCode/${code}`).then(res => {
        return res.data;
    }).catch(err => {
        console.error("查询商品失败：", err);
        return {};
    });
}

export function updateShop(params) {
    return request.post('/shop/save', params).then(res => {
        return res;
    }).catch(err => {
        console.error("更新商品失败：", err);
        throw err;
    });
}
