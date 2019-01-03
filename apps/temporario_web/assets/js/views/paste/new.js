import sjcl from 'sjcl';

import MainView from '../main';
import Payload from '../../helpers/payload';
import { autoresizeTextarea } from '../../helpers/form';

export default class View extends MainView {

    constructor() {
        super();

        this.isSubmitted = false;
    }

    static showEntropyModal() {
        // update progress bar before showing modal
        let entropyPerc = sjcl.random.getProgress(10) * 100;
        $('.js-entropy-progressbar').width(entropyPerc + '%').attr('aria-valuenow', entropyPerc).html(entropyPerc + '%');

        let entropyModal = $('#entropy-modal');
        entropyModal.addClass('is-active');

        const entropyProgressBar = () => {
            let entropyPerc = sjcl.random.getProgress(10) * 100;
            if (entropyPerc < 100) {
                $('#js-entropy-progressbar').width(entropyPerc + '%').attr('value', entropyPerc).html(entropyPerc + '%');
            } else {
                entropyModal.removeClass('is-active');
            }
            window.setTimeout(entropyProgressBar, 100);
        }
    }

    refreshSubmitButton() {
        if (this.isSubmitted === true) {
            return; // stop the function
        }

        let pastePayload = $('#paste_payload');

        // if there is already something in the textarea (browser filled)
        if (pastePayload.val().length > 0) {
            $('#js-paste-submit')
                .addClass('is-focused')
                .removeClass('is-outlined')
                .html('Paste !')
                .prop('disabled', false);
        };

        pastePayload.bind('input propertychange keypress', () => {
            if($('#paste_payload').val().length <= 0) {
                $('#js-paste-submit')
                    .addClass('is-outlined')
                    .removeClass('is-focused')
                    .html('Paste something first...')
                    .prop('disabled', true);
            } else {
                $('#js-paste-submit')
                    .addClass('is-focused')
                    .removeClass('is-outlined')
                    .html('Paste !')
                    .prop('disabled', false);
            }
        });
    }

    processPayload() {
        let payloadInput = $('#paste_payload');
        let payload = payloadInput.val();

        $('#js-paste-submit')
            .html('Compressing...');

        Payload
            .compress(payload)
            .then((compressed) => {
                $('#js-paste-submit')
                    .html('Encrypting...');
                if (sjcl.random.isReady(10) === false) {
                    View.showEntropyModal();
                }
                return Payload.encrypt(compressed)
            })
            .then((encrypted) => {
                $('#js-paste-submit')
                    .html('Sending...');

                let postData = {
                    'paste': {
                        'expiration': $('#paste_expiration').val(),
                        'destroy_on_reading': $('#paste_destroy_on_reading').is(':checked'),
                        'payload': encrypted.data
                }};

                $.ajax({
                    type: 'POST',
                    url: '/api/v1/pastes',
                    data:  postData,
                    dataType: 'json'
                })
                .done((response) => {
                    $('#js-paste-submit')
                        .html('Redirecting...');
                    window.location.href = '/pastes/' + response.paste + '#' + encrypted.key;
                })
                .fail((event) => {
                    $('#js-paste-submit')
                        .removeClass('is-primary')
                        .addClass('is-danger')
                        .html('Failed :(');
                    $('#error-modal').addClass('is-active');
                })
            });

    }
    submitPasteHook() {
        let self = this;
        $('#js-paste-submit').click(function (event) {
            self.isSubmitted = true;
            event.preventDefault();

            $('#paste-form input, #paste-form textarea, #paste-form select, #paste-form button').prop('disabled', true);

            self.processPayload();
        });
    }

    mount() {
        super.mount();

        // set self-updating stuff
        autoresizeTextarea('textarea[data-autoresize]');

        this.refreshSubmitButton();

        this.submitPasteHook();

        // Specific logic here
        console.log('PasteNewView mounted');
    }

    unmount() {
        super.unmount();

        // Specific logic here
        console.log('PasteNewView unmounted');
    }
}