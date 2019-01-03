# Temporar.io

A client-side encrypted pastebin backed by Phoenix & Elixir !

## Getting Started
This is a standard Phoenix umbrella application.

### Prerequisites

 - Elixir (tested on 1.7.3)
 - *nix machine

### Installing

Clone the repository

    git clone https://github.com/achedeuzot/temporar.io.git

Install dependencies

    mix deps.get
    cd apps/temporario_web/assets && npm install
 
Generate development SSL certificates

    mix phx.gen.cert

Run

    mix phx.server

## Running the tests

    mix test

## Deployment

There is no `distillery` packaging yet (see Issues). Right now, the deployment is 
'manual' meaning you have to do the following steps after cloning the repository:

    # From the project root directory
    mix deps.get
    mix deps.compile
    
    # Move to the assets directory
    cd apps/temporario_web/assets
    rm -rf ./node_modules/ && npm install && ./node_modules/.bin/webpack --mode production
    
    # Move to the `apps/temporario_web` directory
    cd ..
    mix phx.digest
    
    # Move back to the project root directory
    cd ../..
    MIX_ENV=prod mix phx.server
    

## Built With

* [Elixir](https://elixir-lang.org/) - Awesome language
* [Phoenix](https://phoenixframework.org/) - Web Framework
* [SJCL](https://github.com/bitwiseshiftleft/sjcl) - Client-side encryption provided by the Stanford Javascript Crypto Library

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/achedeuzot/temporar.io/tags). 

## Authors

* **Klemen Sever** - *Initial work* - [achedeuzot](https://github.com/achedeuzot)

See also the list of [contributors](https://github.com/achedeuzot/temporar.io/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

 * Hat tip to anyone whose code was used
 * https://0bin.net & similar projects
 * README template by [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
 
