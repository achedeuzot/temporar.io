import MainView from '../main';
import Payload from '../../helpers/payload';
import hljs from 'highlight.js';
import 'highlightjs-line-numbers.js';
import {getTextCodeScore} from "../../helpers/code";

export default class View extends MainView {

    constructor() {
        super();
    }

    highlightWithLineNumbers(content) {
        const highlightedResult = hljs.highlightAuto(content);
        const highlightedContent = highlightedResult.value;

        const withLineNumbers = hljs.lineNumbersValue(highlightedContent);

        return `<pre id="paste_content" class="is-rounded is-bordered pan">${withLineNumbers}</pre>`;
    }

    loadPayload() {
        let self = this;
        let payloadInpt = $('#paste_payload');
        let payload = payloadInpt.val();

        let keyb64 = window.location.hash.substr(1);

        $('#paste_load_status').val('Decrypting...');

        Payload
            .decrypt(keyb64, payload)
            .then((decrypted) => {
                $('#paste_load_status').val('Decompressing...');
                return Payload.decompress(decrypted);
            })
            .then((decompressed) => {
                $('#paste_load_status').val('Paste loaded');

                $('#paste_payload').remove();
                if (getTextCodeScore(decompressed) > 100) {
                    const res = self.highlightWithLineNumbers(decompressed);
                    $('#paste').append(res);
                } else {
                    const input = $('<pre>', {id: 'paste_content', class: 'is-rounded is-bordered pan'}).text(decompressed);
                    $('#paste').append(input);
                    const info = $('<div>', {id: 'paste_coloration', class: 'notification is-primary'});
                    info.html('The paste did not seem to be code, so it was not colorized.\n' +
                              'You can <a id="js-force-coloration" href="#">force the coloration</a>\n');
                    $('#paste').prepend(info);
                }

                $('#paste_load').addClass('is-hidden');
                $('#paste').removeClass('is-hidden');

                $('#js-force-coloration').on('click', function (e) {
                    e.preventDefault();
                    const res = self.highlightWithLineNumbers($('#paste_content').html());
                    $('#paste').html(res);
                    $('#paste_coloration').remove();
                });
            });

    }

    mount() {
        super.mount();

        this.loadPayload();

        // Specific logic here
        console.log('PasteNewView mounted');
    }

    unmount() {
        super.unmount();

        // Specific logic here
        console.log('PasteNewView unmounted');
    }
}