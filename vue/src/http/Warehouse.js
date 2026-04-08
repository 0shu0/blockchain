import request from "./request";

export function addWarehouse(params) {
    return request.post('/warehouse/save', params).then(res => {
        return res;
    });
}

export function deleteWarehouse(id) {
    return request.delete(`/warehouse/deleteById/${id}`).then(res => {
        return res;
    });
}

export function getAllWarehouse() {
    return request.get('/warehouse/findAll').then(res => {
        return res.data;
    }).catch(err => {
        console.error("加载仓库列表失败：", err);
        return [];
    });
}

export function getWarehouseById(id) {
    return request.get(`/warehouse/findById/${id}`).then(res => {
        return res.data;
    });
}

export function updateWarehouse(params) {
    return request.post('/warehouse/save', params).then(res => {
        return res;
    });
}