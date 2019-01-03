
export function getTextCodeScore(text) {

    const code_chars = /[A-Z]{3}[A-Z]+|\.[a-z]|[=:<>{}\[\]$_'"&]| {2}|\t/g;
    const comments = /(:?\/\*|<!--)(:?.|\n)*?(:?\*\/|-->)|(\/\/|#)(.*?)\n/g;
    const formating = /[-*=_+]{4,}/;

    let total = 0;
    let size = 0;
    let m = text.match(comments);
    if (m) {
        total += text.match(comments).length;
    }
    text = text.replace(comments, '');
    text.replace(formating, '');
    text = text.split('\n');
    for (let i = 0; i < text.length; i++) {
        let line = text[i];
        size += line.length;
        let match = line.replace(formating, '').match(code_chars);
        if (match) {
            total += match.length;
        }
    }

    return total * 1000 / size;
};
