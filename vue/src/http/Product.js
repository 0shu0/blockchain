import webaseHttp from "@/utils/webaseHttp";

let contractAddress = "0xbcb94a871cc3f3f2b4da5cfa4e1ccf4938f5fa7a";
let user = "0x914bec892e9755092eb8bb8d4ebf697c90be2a33";

export function addProduct(params) {
    let pam = {
    {"groupId":"1","user":"0x65183d971dff322a603a0c96f61a13bab3be0ab0","contractName":"Product","contractPath":"sy","version":"","funcName":"addObject","funcParam":["1","1","1","1"],"contractAddress":"0x90559854e701adea639be40fe8b08c6b10143214","contractAbi":[{"constant":false,"inputs":[{"name":"_name","type":"string","value":"1"},{"name":"_origin","type":"string","value":"1"},{"name":"_manufacturer","type":"string","value":"1"},{"name":"_traceCode","type":"string","value":"1"}],"name":"addObject","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function","funcId":2}],"useAes":false,"useCns":false,"cnsName":""}
    }
    return webaseHttp.post('/', pam).then(res => {
        return res;
    })
}
export function deleteProduct(id) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "deleteObject",
        "funcParam": [id],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [{"name": "_id", "type": "string", "value": id}],
            "name": "deleteObject",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function",
            "funcId": 2
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    }
    return webaseHttp.post('/', pam).then(res => {
        return res;
    });
}
export function getAllProduct() {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "getAllObjects",
        "funcParam": [],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [],
            "name": "getAllObjects",
            "outputs": [{
                "components": [                     {"name": "traceCode", "type": "string"}
,                    {"name": "origin", "type": "string"}
,                    {"name": "name", "type": "string"}
,                    {"name": "id", "type": "string"}
,                    {"name": "manufacturer", "type": "string"}
], "name": "", "type": "tuple[]"
            }],
            "payable": false,
            "stateMutability": "view",
            "type": "function",
            "funcId": 4
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    };
    return webaseHttp.post('/', params).then(res => {
        let objs = res.map(item => {
            return cvtRes(item);
        });
        return objs;
    });
}
export function getProductById(id) {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "getObjectById",
        "funcParam": [id],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [{"name": "_id", "type": "string", "value": id}],
            "name": "getObjectById",
            "outputs": [{
                "components": [                     {"name": "traceCode", "type": "string"}
,                    {"name": "origin", "type": "string"}
,                    {"name": "name", "type": "string"}
,                    {"name": "id", "type": "string"}
,                    {"name": "manufacturer", "type": "string"}
], "name": "", "type": "tuple"
            }],
            "payable": false,
            "stateMutability": "view",
            "type": "function",
            "funcId": 1
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    };
    return webaseHttp.post('/', params).then(res => {
        return res;
    })
}
export function getProductByCode(id) {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "getObjectByCode",
        "funcParam": [id],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [{"name": "_code", "type": "string", "value": id}],
            "name": "getObjectByCode",
            "outputs": [{
                "components": [                     {"name": "traceCode", "type": "string"}
,                    {"name": "origin", "type": "string"}
,                    {"name": "name", "type": "string"}
,                    {"name": "id", "type": "string"}
,                    {"name": "manufacturer", "type": "string"}
], "name": "", "type": "tuple"
            }],
            "payable": false,
            "stateMutability": "view",
            "type": "function",
            "funcId": 1
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    };
    return webaseHttp.post('/', params).then(res => {
        return cvtRes(res);
    })
}
export function updateProduct(params) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "updateObject",
        "funcParam": [ params.traceCode ,params.origin ,params.name ,params.id ,params.manufacturer],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [                  {"name": "_traceCode", "type": "string", "value": params.traceCode}
,                {"name": "_origin", "type": "string", "value": params.origin}
,                {"name": "_name", "type": "string", "value": params.name}
,                {"name": "_id", "type": "string", "value": params.id}
,                {"name": "_manufacturer", "type": "string", "value": params.manufacturer}
],
            "name": "updateObject",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function",
            "funcId": 3
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    };
    return webaseHttp.post('/', pam).then(res => {
        return res;
    });
}
function cvtRes(item) {
    return {
            "traceCode": item[0] || '',
            "origin": item[1] || '',
            "name": item[2] || '',
            "id": item[3] || '',
            "manufacturer": item[4] || '',
    }
}
