import sjcl from 'sjcl';
import pako from 'pako';

export default class Payload {

    static compress(data) {
        return Promise.resolve(pako.deflate(data));
    }

    static decompress(data) {
        return new Promise((resolve, reject) => {
            try {
                resolve(pako.inflate(data, { to: 'string' }));
            } catch (err) {
                reject(err);
            }
        });
    }

    static encrypt(data) {
        // convert to base64url
        // data = sjcl.codec.base64url.fromBits(data);
        return new Promise((resolve, _) => {
            const waitForEntropy = () => {
                if(sjcl.random.isReady(10) === false) {
                    window.setTimeout(waitForEntropy, 100);
                } else {
                    let key = sjcl.random.randomWords(8, 10); //8x4 bytes 256 bit key, level 10 paranoia
                    data = sjcl.codec.base64url.fromBits(data); // encode in base64
                    data = sjcl.encrypt(key, data, {ts: 128, ks: 256});
                    resolve({
                        "key": sjcl.codec.base64url.fromBits(key),
                        "data": data
                    });
                }
            };

            waitForEntropy();
        });
    }

    static decrypt(key, data) {
        return new Promise((resolve, _) => {
            key = sjcl.codec.base64url.toBits(key);
            let decrypted = sjcl.decrypt(key, data, {ts: 128, ks: 256});
            let tmp = sjcl.codec.base64url.toBits(decrypted);
            resolve(tmp);
        });
    }
}