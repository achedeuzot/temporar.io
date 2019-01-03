import sjcl from 'sjcl';

export default class MainView {
    mount() {

        // Initialize random ASAP !
        sjcl.random.setDefaultParanoia(10); // set paranoia to 512 bits mini
        sjcl.random.startCollectors(); // start random collectors ASAP.

        // Manage the Navbar collapse logic
        $(document).ready(function() {

            // Check for click events on the navbar burger icon
            $(".navbar-burger").click(function() {

                // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
                $(".navbar-burger").toggleClass("is-active");
                $(".navbar-menu").toggleClass("is-active");

            });
        });

        // This will be executed when the document loads...
        console.log('MainView mounted');
    }

    unmount() {
        // This will be executed when the document unloads...
        console.log('MainView unmounted');
    }
}
