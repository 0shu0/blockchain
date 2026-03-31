
export function generateUUID() {
    // RFC4122 v4 UUID
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        const r = Math.random() * 16 | 0; // 生成 0-15 的随机数
        const v = c === 'x' ? r : (r & 0x3 | 0x8); // 确保格式符合 UUID 4
        return v.toString(16); // 返回十六进制格式
    });
}
